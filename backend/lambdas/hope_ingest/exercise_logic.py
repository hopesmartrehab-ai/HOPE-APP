import math
from datetime import datetime

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
# APPLY FILTERS
# ==============================
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
    fsr1_f = moving_average(fsr1)
    fsr2_f = moving_average(fsr2)
    emg_f  = low_pass(emg)
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

def compute_rom(data, max_delta=20):
    if not data:
        return 0
    angle = 0
    prev = data[0]
    angles = []
    for i in range(1, len(data)):
        dt = (data[i]["time"] - prev["time"]) / 1000
        dt = max(dt, 0)
        delta = data[i]["gx"] * dt
        if abs(delta) > max_delta:
            delta = math.copysign(max_delta, delta)
        angle += delta
        angle = max(min(angle, 90), -90)
        angles.append(angle)
        prev = data[i]
    return max(angles) - min(angles) if angles else 0

def compute_trajectory(data, max_delta=0.5):
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
        if mag > max_delta:
            dx *= max_delta / mag
            dy *= max_delta / mag
            dz *= max_delta / mag
            mag = max_delta
        vectors.append((dx/mag, dy/mag, dz/mag))
    if len(vectors) < 2:
        return 0
    dots = [sum(vectors[i][j]*vectors[i-1][j] for j in range(3)) for i in range(1, len(vectors))]
    return sum(dots) / len(dots) if dots else 0

def compute_deviation(data):
    if not data:
        return 0
    return max([math.sqrt(d["ax"]**2 + d["ay"]**2 + d["az"]**2) for d in data]) - \
           min([math.sqrt(d["ax"]**2 + d["ay"]**2 + d["az"]**2) for d in data])

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
    rms = math.sqrt(sum(v**2 for v in vals) / len(vals))
    return rms

# ==============================
# EXERCISE
# ==============================
def get_motivational_message(percent):
    if percent > 90: return "Great job! Keep it up!"
    elif percent > 70: return "Good work! You're improving"
    elif percent > 50: return "Not bad, keep practicing"
    else: return "Keep trying, you can do it"

def run_exercise(data, exercise_name):
    if not data or len(data) < 2:
        return {"error": "Not enough data"}

    data = apply_filters(data)
    feature_scores = {}

    if exercise_name == "Reach":
        speed = compute_speed(data)
        rom   = compute_rom(data)
        traj  = compute_trajectory(data)
        dev   = compute_deviation(data)
        feature_scores["speed"] = min(max(speed / 3 * 100, 0), 100)
        feature_scores["ROM"]   = min(max(rom / 90 * 100, 0), 100)
        feature_scores["trajectory"] = min(max(traj * 100, 0), 100)
        feature_scores["deviation"] = max(0, min(100, 100 - dev / 2000 * 100))
    elif exercise_name == "Grasp":
        force = compute_force(data)
        flex  = compute_flex(data)
        feature_scores["force"] = min(max(force, 0), 100)
        feature_scores["flex"]  = min(max(flex, 0), 100)
    elif exercise_name == "Manipulation":
        traj = compute_trajectory(data)
        duration = max((data[-1]["time"] - data[0]["time"]) / 1000, 0.01)
        feature_scores["trajectory"] = min(max(traj * 100, 0), 100)
        feature_scores["duration"]   = max(0, min(100, 100 - duration * 10))
    elif exercise_name == "Release":
        force = compute_force(data)
        flex  = compute_flex(data)
        feature_scores["force"] = max(0, min(100 - force, 100))
        feature_scores["flex"]  = max(0, min(100 - flex, 100))
    else:
        return {"error": "Unknown exercise"}

    overall = sum(feature_scores.values()) / len(feature_scores)
    message = get_motivational_message(overall)

    return {
        "exercise": exercise_name,
        "features": {k: round(v, 1) for k, v in feature_scores.items()},
        "overall_percent": round(overall, 1),
        "message": message,
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }
