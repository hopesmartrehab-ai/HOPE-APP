"""Crop the HOPE logo's white border and emit PNG variants for in-app, icon, and splash.

Run once: `python3 tools/prep_logo.py` from the flutter_app directory.
Requires Pillow (`pip install pillow`).
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "assets" / "logo.jpeg"
OUT_LOGO = ROOT / "assets" / "logo.png"
OUT_ICON = ROOT / "assets" / "icon" / "app_icon.png"
OUT_SPLASH = ROOT / "assets" / "splash" / "splash_logo.png"

WHITE_THRESHOLD = 215  # pixels brighter than this are treated as background
PADDING_RATIO = 0.08   # 8% padding around the cropped logo (in-app use)
ICON_PADDING_RATIO = 0.04  # tighter padding for app icon so glyph fills tile


def crop_white_border(img: Image.Image) -> Image.Image:
    gray = ImageOps.grayscale(img)
    # invert so dark logo → bright, white bg → dark; getbbox ignores black
    mask = gray.point(lambda p: 0 if p > WHITE_THRESHOLD else 255)
    bbox = mask.getbbox()
    if bbox is None:
        return img
    return img.crop(bbox)


def pad_to_square(img: Image.Image, bg=(255, 255, 255), padding_ratio: float = PADDING_RATIO) -> Image.Image:
    w, h = img.size
    side = max(w, h)
    pad = int(side * padding_ratio)
    canvas_side = side + 2 * pad
    canvas = Image.new("RGB", (canvas_side, canvas_side), bg)
    canvas.paste(img, (pad + (side - w) // 2, pad + (side - h) // 2))
    return canvas


def key_out_background(img: Image.Image) -> Image.Image:
    """Turn the off-white background transparent based on luminance."""
    rgba = img.convert("RGBA")
    pixels = rgba.load()
    w, h = rgba.size
    for y in range(h):
        for x in range(w):
            r, g, b, _ = pixels[x, y]
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            if lum >= WHITE_THRESHOLD:
                pixels[x, y] = (r, g, b, 0)
            elif lum >= WHITE_THRESHOLD - 20:
                # Soft edge: fade alpha between threshold-20 and threshold
                alpha = int(255 * (WHITE_THRESHOLD - lum) / 20)
                pixels[x, y] = (r, g, b, alpha)
    return rgba


def pad_to_square_transparent(img: Image.Image, canvas_side: int, logo_side: int) -> Image.Image:
    keyed = key_out_background(img)
    scaled = keyed.copy()
    scaled.thumbnail((logo_side, logo_side), Image.LANCZOS)
    canvas = Image.new("RGBA", (canvas_side, canvas_side), (255, 255, 255, 0))
    w, h = scaled.size
    canvas.paste(scaled, ((canvas_side - w) // 2, (canvas_side - h) // 2), scaled)
    return canvas


def main() -> None:
    if not SRC.exists():
        raise SystemExit(f"Source logo not found at {SRC}")

    OUT_ICON.parent.mkdir(parents=True, exist_ok=True)
    OUT_SPLASH.parent.mkdir(parents=True, exist_ok=True)

    src = Image.open(SRC).convert("RGB")
    cropped = crop_white_border(src)

    # In-app logo (transparent bg, 1024) — blends onto any scaffold color
    logo = pad_to_square_transparent(cropped, canvas_side=1024, logo_side=1000)
    logo.save(OUT_LOGO, "PNG", optimize=True)

    # App icon (transparent bg, 1024) — OS adds its own tile; transparent avoids
    # white letterboxing. iOS config uses background_color_ios to fill the tile.
    icon = pad_to_square_transparent(cropped, canvas_side=1024, logo_side=1000)
    icon.save(OUT_ICON, "PNG", optimize=True)

    # Splash logo: transparent bg with generous breathing room
    splash = pad_to_square_transparent(cropped, canvas_side=1152, logo_side=512)
    splash.save(OUT_SPLASH, "PNG", optimize=True)

    print(f"Wrote: {OUT_LOGO.relative_to(ROOT)}")
    print(f"Wrote: {OUT_ICON.relative_to(ROOT)}")
    print(f"Wrote: {OUT_SPLASH.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
