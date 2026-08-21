# HOPE Demo Notes

Things you should know before running the demo, but that aren't visible in the app's UI.

## Secret debug gesture

The debug panel (HTTP request log, state-change log, app info) is hidden behind a tap sequence anywhere on screen:

> **4 taps on the right third → 3 taps on the left third**, all within 3 seconds.

Implemented in `flutter_app/lib/debug/debug_overlay.dart`. The gesture is intentionally undocumented inside the app so the patient can't trip it accidentally.

## Hardcoded values

These are fixed and assumed for the single-user demo:

| What | Where | Value |
|---|---|---|
| WiFi SSID/password | `firmware/hope_glove/hope_glove.ino` | Hardcoded, change before flashing if your network changes |
| Glove device ID | firmware + `flutter_app/lib/config.dart` (`defaultDeviceId`) | `hope-glove-01` — must match on both sides |
| API base URL | `flutter_app/lib/config.dart` + `firmware/hope_glove/hope_glove.ino` | `https://jk7o08xdb6.execute-api.eu-west-3.amazonaws.com/prod` (re-flash firmware if this ever changes) |

## Demo flow expectations

- Launch app → tap **Patient** → session is created and the device is auto-linked (single glove, no picker).
- Polling for assessment / exercise: every 1 second, capped at 60 seconds.
- "Simulate Glove" button is visible at all times — useful if the physical glove misbehaves mid-demo.
- Video recording on the exercise screen records at ~480p (medium preset) so uploads stay quick on iPhone / modern Android. Video is uploaded automatically when the user taps Stop.
- Practitioner mode: tap **Doctor** to see all sessions. Open one for the assessment / exercise / info tabs and the recorded video (if any). The trash icon in the AppBar deletes the session and its artifacts.
- After exercise, tap **Finish Session** to return to welcome. There is no final-summary screen by design.

## What happens if the user kills the app mid-session

The session is orphaned in DynamoDB (status stays at whatever it was) and the next launch starts fresh. This is intentional — see `QUESTIONS.md` D24/F36.

## AWS region

Everything is in **eu-west-3 (Paris)**. Don't deploy to any other region — the deploy script defaults to eu-west-3 and the Lambda S3 client is wired for it.
