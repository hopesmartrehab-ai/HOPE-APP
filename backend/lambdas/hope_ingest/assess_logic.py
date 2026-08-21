import math

# ==============================
# FILTERS
# ==============================
def moving_average(values, window=5):
    if not values:
        return []
    result = []
    for i in range(len(values)):
        start = max(0, i - window + 1)
        avg = sum(values[start:i+1]) / (i - start + 1)
        result.append(avg)
    return result

def low_pass(values, alpha=0.1):
    if not values:
        return []
    filtered = [values[0]]
    for i in range(1, len(values)):
        filtered.append(alpha * values[i] + (1 - alpha) * filtered[-1])
    return filtered

# ==============================
# APPLY FILTERS TO DATA
# ==============================
# Canonical per-sample schema lives in firmware/FIRMWARE.md#sensors.
# Each item in `data` has: time (ms since boot), flex1/flex2 (0-90°),
# fsr1/fsr2 (0-100, 0=no force), emg (0-4000 rectified), ax/ay/az and
# gx/gy/gz (raw MPU6050 int16 LSB at ±2g / ±250°/s).
def apply_filters(data):
    if not data:
        return []

    flex1 = [d.get("flex1", 0) for d in data]
    flex2 = [d.get("flex2", 0) for d in data]
    fsr1  = [d.get("fsr1", 0) for d in data]
    fsr2  = [d.get("fsr2", 0) for d in data]
    emg   = [d.get("emg", 0) for d in data]
    ax = [d.get("ax", 0) for d in data]
    ay = [d.get("ay", 0) for d in data]
    az = [d.get("az", 0) for d in data]
    gx = [d.get("gx", 0) for d in data]
    gy = [d.get("gy", 0) for d in data]
    gz = [d.get("gz", 0) for d in data]

    flex1_f = moving_average(flex1)
    flex2_f = moving_average(flex2)
    fsr1_f  = moving_average(fsr1)
    fsr2_f  = moving_average(fsr2)
    emg_f   = low_pass(emg)
    ax_f = low_pass(ax)
    ay_f = low_pass(ay)
    az_f = low_pass(az)
    gx_f = low_pass(gx)
    gy_f = low_pass(gy)
    gz_f = low_pass(gz)

    filtered_data = []
    for i in range(len(data)):
        filtered_data.append({
            "time": data[i].get("time", 0),
            "flex1": flex1_f[i],
            "flex2": flex2_f[i],
            "fsr1": fsr1_f[i],
            "fsr2": fsr2_f[i],
            "emg": emg_f[i],
            "ax": ax_f[i],
            "ay": ay_f[i],
            "az": az_f[i],
            "gx": gx_f[i],
            "gy": gy_f[i],
            "gz": gz_f[i],
        })
    return filtered_data

# ==============================
# FEATURE FUNCTIONS
# ==============================
def accel_mag(d):
    return math.sqrt(d["ax"]**2 + d["ay"]**2 + d["az"]**2)

def compute_speed(data):
    if not data:
        return 0
    mags = [accel_mag(d) for d in data]
    return sum(mags) / len(mags) if mags else 0

def compute_rom(data):
    if not data:
        return 0
    angle = 0
    prev = data[0]
    angles = []
    for i in range(1, len(data)):
        dt = max((data[i]["time"] - prev["time"]) / 1000, 0)
        angle += data[i]["gx"] * dt
        angle = max(min(angle, 90), -90)
        angles.append(angle)
        prev = data[i]
    return max(angles) - min(angles) if angles else 0

def compute_trajectory(data):
    if not data or len(data) < 2:
        return 0
    vectors = []
    for i in range(1, len(data)):
        dx = data[i]["ax"] - data[i-1]["ax"]
        dy = data[i]["ay"] - data[i-1]["ay"]
        dz = data[i]["az"] - data[i-1]["az"]
        mag = math.sqrt(dx**2 + dy**2 + dz**2)
        if mag < 1e-3:
            continue
        vectors.append((dx/mag, dy/mag, dz/mag))
    if len(vectors) < 2:
        return 0
    dots = [sum(vectors[i][j]*vectors[i-1][j] for j in range(3)) for i in range(1, len(vectors))]
    return sum(dots) / len(dots) if dots else 0

def compute_deviation(data):
    if not data:
        return 0
    return max([accel_mag(d) for d in data]) - min([accel_mag(d) for d in data])

def compute_flex(data):
    if not data:
        return 0
    f1 = [d["flex1"] for d in data]
    f2 = [d["flex2"] for d in data]
    return (sum(f1) + sum(f2)) / (len(f1) + len(f2))

def compute_force(data):
    if not data:
        return 0
    f1 = [d["fsr1"] for d in data]
    f2 = [d["fsr2"] for d in data]
    return (sum(f1) + sum(f2)) / (len(f1) + len(f2))

def compute_emg(data):
    if not data:
        return 0
    vals = [d["emg"] for d in data]
    square_sum = sum([v**2 for v in vals])
    return math.sqrt(square_sum / len(vals)) if vals else 0

# ==============================
# ASSESSMENT
# ==============================
def assess_reach(speed, rom, traj, dev):
    return rom > 60 and 1 < speed < 3 and traj > 0.85 and dev < 2000

def assess_grasp(force, flex):
    return force > 50 and flex > 40

def assess_manipulation(traj, duration):
    return traj > 0.8 and duration < 6

def assess_release(force, flex):
    return force < 20 and flex < 20

def assess_session(data):
    data = apply_filters(data)

    speed = compute_speed(data)
    rom = compute_rom(data)
    traj = compute_trajectory(data)
    dev = compute_deviation(data)
    flex = compute_flex(data)
    force = compute_force(data)
    emg = compute_emg(data)
    duration = (data[-1]["time"] - data[0]["time"]) / 1000

    results = {
        "Reach": assess_reach(speed, rom, traj, dev),
        "Grasp": assess_grasp(force, flex),
        "Manipulation": assess_manipulation(traj, duration),
        "Release": assess_release(force, flex)
    }

    needed_functions = [k for k, v in results.items() if not v]

    return {
        "results": results,
        "needed_training": needed_functions,
        "features": {
            "speed": round(speed, 2),
            "rom": round(rom, 2),
            "trajectory": round(traj, 2),
            "deviation": round(dev, 2),
            "flex": round(flex, 2),
            "force": round(force, 2),
            "emg": round(emg, 2)
        }
    }
