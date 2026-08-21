#!/usr/bin/env python3
"""
HOPE Smart Rehabilitation Glove - Demo Simulation Script
Simulates a full patient session flow against the live API with fancy visual output.
"""

import requests
import time
import sys
import random
import json
from pathlib import Path

# Try to read API URL from file, fallback to default
API_URL_FILE = Path(__file__).parent / "backend" / "infra" / ".api_url"
try:
    API_BASE = API_URL_FILE.read_text().strip()
except FileNotFoundError:
    API_BASE = "https://unj4s6yf6b.execute-api.us-east-1.amazonaws.com/prod"

# ANSI Color Codes
RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
MAGENTA = "\033[95m"
BLUE = "\033[94m"
WHITE = "\033[97m"

# Unicode symbols
CHECK = "✓"
CROSS = "✗"
ARROW = "→"
BULLET = "•"
SPINNER = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]

# Device ID for ESP32 glove simulation
DEVICE_ID = "hope-glove-01"


def print_banner():
    """Print fancy ASCII banner."""
    banner = f"""
{CYAN}{BOLD}╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   {WHITE}██╗  ██╗ ██████╗ ██████╗ ██████╗ {CYAN}                              ║
║   {WHITE}██║  ██║██╔═══██╗██╔══██╗██╔══██╗{CYAN}                             ║
║   {WHITE}███████║██║   ██║██████╔╝██████╔╝{CYAN}                             ║
║   {WHITE}██╔══██║██║   ██║██╔══██╗██╔══██╗{CYAN}                             ║
║   {WHITE}██║  ██║╚██████╔╝██║  ██║██████╔╝{CYAN}                             ║
║   {WHITE}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ {CYAN}                             ║
║                                                              ║
║   {MAGENTA}Smart Rehabilitation Glove{CYAN}                                  ║
║   {DIM}AI-Powered Hand Recovery System{CYAN}                               ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝{RESET}
"""
    print(banner)
    time.sleep(0.5)


def animate_dots(text, duration=2.0, interval=0.3):
    """Show animated dots after text."""
    dots = 0
    start = time.time()
    while time.time() - start < duration:
        sys.stdout.write(f"\r{CYAN}{text}{'.' * (dots % 4)}{'   '[:3 - dots % 4]}{RESET}")
        sys.stdout.flush()
        dots += 1
        time.sleep(interval)
    sys.stdout.write(f"\r{GREEN}{CHECK} {text} done{RESET}    \n")
    sys.stdout.flush()


def spinner(text, duration=3.0, check_done=False):
    """Show spinning animation with text."""
    start = time.time()
    i = 0
    while time.time() - start < duration:
        elapsed = time.time() - start
        sys.stdout.write(f"\r{CYAN}{SPINNER[i % len(SPINNER)]} {text} ({elapsed:.1f}s){RESET}")
        sys.stdout.flush()
        i += 1
        time.sleep(0.1)
    if check_done:
        sys.stdout.write(f"\r{GREEN}{CHECK} {text} complete{RESET}    \n")
    else:
        sys.stdout.write(f"\r{' ' * 60}\r")
    sys.stdout.flush()


def blink_text(text, blinks=5, interval=0.3):
    """Blink text on and off."""
    for i in range(blinks):
        if i % 2 == 0:
            sys.stdout.write(f"\r{YELLOW}{BOLD}{text}{RESET}")
        else:
            sys.stdout.write(f"\r{DIM}{text}{RESET}")
        sys.stdout.flush()
        time.sleep(interval)
    sys.stdout.write(f"\r{GREEN}{CHECK} {text}{RESET}    \n")
    sys.stdout.flush()


def print_section(title):
    """Print a section header."""
    print(f"\n{BOLD}{MAGENTA}{'═' * 60}{RESET}")
    print(f"{BOLD}{MAGENTA}  {title}{RESET}")
    print(f"{BOLD}{MAGENTA}{'═' * 60}{RESET}\n")


def print_box(title, content_lines, color=CYAN):
    """Print a nice box with content."""
    width = max(len(title), max(len(line) for line in content_lines)) + 4
    print(f"{color}┌{'─' * (width - 2)}┐{RESET}")
    print(f"{color}│ {BOLD}{title.center(width - 4)}{RESET}{color} │{RESET}")
    print(f"{color}├{'─' * (width - 2)}┤{RESET}")
    for line in content_lines:
        print(f"{color}│{RESET} {line.ljust(width - 4)} {color}│{RESET}")
    print(f"{color}└{'─' * (width - 2)}┘{RESET}")


def print_progress_bar(label, value, max_val=100, width=30, color=GREEN):
    """Print a progress bar."""
    filled = int((value / max_val) * width)
    bar = "█" * filled + "░" * (width - filled)
    print(f"  {label}: {color}{bar}{RESET} {value:.0f}%")


def generate_sensor_sample(base_values=None, sample_index=0):
    """Generate realistic sensor data sample matching ESP32 output ranges.

    Backend expects: flex1, flex2, fsr1, fsr2, emg, ax, ay, az, gx, gy, gz, time
    """
    if base_values is None:
        base_values = {
            'flex1': 45, 'flex2': 50,  # Two flex sensors
            'fsr1': 40, 'fsr2': 35,    # Two pressure sensors
            'emg': 300,
            'ax': 0, 'ay': 0, 'az': 16384,  # ~1g in z-axis
            'gx': 0, 'gy': 0, 'gz': 0
        }

    sample = {}
    for key, base in base_values.items():
        if key.startswith('flex'):
            # Flex sensors: 0-90 range with noise
            noise = random.uniform(-5, 5)
            sample[key] = max(0, min(90, base + noise))
        elif key.startswith('fsr'):
            # FSR sensors: 0-100 range with noise
            noise = random.uniform(-8, 8)
            sample[key] = max(0, min(100, base + noise))
        elif key == 'emg':
            # EMG: ~300 base with more variation
            noise = random.uniform(-50, 50)
            sample[key] = max(0, int(base + noise))
        elif key in ('ax', 'ay', 'az'):
            # Accelerometer: ±16384 range (±2g)
            noise = random.uniform(-200, 200)
            sample[key] = int(base + noise)
        else:  # gyroscope
            # Gyroscope: raw MPU6050 int16 LSB at ±250°/s (131 LSB per °/s).
            # See firmware/FIRMWARE.md#sensors for the canonical schema.
            noise = random.uniform(-30, 30)
            sample[key] = int(base + noise)

    # Use relative time in milliseconds from start of session
    sample['time'] = sample_index * 50  # 50ms intervals
    return sample


def generate_assessment_data(duration_samples=100):
    """Generate realistic assessment sensor data (100 samples over ~5 seconds)."""
    data = []
    for i in range(duration_samples):
        # Simulate varying hand positions during assessment
        base = {
            'flex1': 30 + 30 * (0.5 + 0.5 * (i % 20) / 20),
            'flex2': 35 + 25 * (0.5 + 0.5 * (i % 25) / 25),
            'fsr1': 20 + 40 * random.uniform(0.8, 1.2),
            'fsr2': 15 + 35 * random.uniform(0.8, 1.2),
            'emg': 250 + 100 * random.uniform(0, 1),
            'ax': 1000 * random.uniform(-1, 1),
            'ay': 500 * random.uniform(-1, 1),
            'az': 16000 + 500 * random.uniform(-1, 1),
            'gx': 100 * random.uniform(-1, 1),
            'gy': 80 * random.uniform(-1, 1),
            'gz': 120 * random.uniform(-1, 1)
        }
        data.append(generate_sensor_sample(base, i))
        time.sleep(0.01)  # Simulate 50ms intervals (but faster for demo)

    return data


def generate_exercise_data(exercise_name, samples=50):
    """Generate exercise-specific sensor data."""
    data = []

    # Different movement patterns for different exercises
    if "grip" in exercise_name.lower():
        # Grip strength: repeated gripping motion
        for i in range(samples):
            grip_intensity = 0.5 + 0.5 * (1 + (i % 10) / 10)
            base = {
                'flex1': 50 + 30 * grip_intensity,
                'flex2': 55 + 25 * grip_intensity,
                'fsr1': 30 + 50 * grip_intensity,
                'fsr2': 25 + 55 * grip_intensity,
                'emg': 300 + 200 * grip_intensity,
                'ax': 500 * random.uniform(-1, 1),
                'ay': 300 * random.uniform(-1, 1),
                'az': 16200 + 400 * random.uniform(-1, 1),
                'gx': 50 * random.uniform(-1, 1),
                'gy': 40 * random.uniform(-1, 1),
                'gz': 60 * random.uniform(-1, 1)
            }
            data.append(generate_sensor_sample(base, i))
            time.sleep(0.01)

    elif "pinch" in exercise_name.lower():
        # Pinch: thumb and index finger
        for i in range(samples):
            pinch_intensity = 0.5 + 0.5 * abs((i % 20) / 20 - 0.5) * 2
            base = {
                'flex1': 40 + 40 * pinch_intensity,
                'flex2': 45 + 35 * pinch_intensity,
                'fsr1': 40 + 45 * pinch_intensity,
                'fsr2': 35 + 50 * pinch_intensity,
                'emg': 280 + 150 * pinch_intensity,
                'ax': 200 * random.uniform(-1, 1),
                'ay': 150 * random.uniform(-1, 1),
                'az': 16100 + 300 * random.uniform(-1, 1),
                'gx': 30 * random.uniform(-1, 1),
                'gy': 25 * random.uniform(-1, 1),
                'gz': 40 * random.uniform(-1, 1)
            }
            data.append(generate_sensor_sample(base, i))
            time.sleep(0.01)

    else:  # Generic extension/flexion
        for i in range(samples):
            flex_intensity = 0.5 + 0.5 * (i % 15) / 15
            base = {
                'flex1': 30 + 40 * flex_intensity,
                'flex2': 35 + 35 * flex_intensity,
                'fsr1': 20 + 30 * random.uniform(0, 1),
                'fsr2': 15 + 35 * random.uniform(0, 1),
                'emg': 250 + 100 * random.uniform(0, 1),
                'ax': 300 * random.uniform(-1, 1),
                'ay': 200 * random.uniform(-1, 1),
                'az': 16150 + 350 * random.uniform(-1, 1),
                'gx': 40 * random.uniform(-1, 1),
                'gy': 35 * random.uniform(-1, 1),
                'gz': 45 * random.uniform(-1, 1)
            }
            data.append(generate_sensor_sample(base, i))
            time.sleep(0.01)

    return data


def print_sensor_feed(data, samples_to_show=8):
    """Show live sensor feed like serial monitor."""
    print(f"\n{DIM}{'─' * 80}{RESET}")
    print(f"{BOLD}{CYAN}  SENSOR FEED (Live){RESET}\n")

    for i, sample in enumerate(data[:samples_to_show]):
        # Format sensor line (using backend field names: flex1, flex2, fsr1, fsr2)
        flex_str = f"F1:{sample['flex1']:5.1f} F2:{sample['flex2']:5.1f}"
        fsr_str = f"P1:{sample['fsr1']:5.1f} P2:{sample['fsr2']:5.1f}"
        emg_str = f"EMG:{sample['emg']:4d}"
        accel_str = f"A:[{sample['ax']:6d},{sample['ay']:6d},{sample['az']:6d}]"
        gyro_str = f"G:[{sample['gx']:4d},{sample['gy']:4d},{sample['gz']:4d}]"

        sys.stdout.write(f"\r  {DIM}#{i+1:03d}{RESET} {YELLOW}{flex_str}{RESET} {MAGENTA}{fsr_str}{RESET} {BLUE}{emg_str}{RESET} {CYAN}{accel_str}{RESET} {GREEN}{gyro_str}{RESET}\n")
        sys.stdout.flush()
        time.sleep(0.15)

    if len(data) > samples_to_show:
        print(f"  {DIM}... {len(data) - samples_to_show} more samples{RESET}")

    print(f"{DIM}{'─' * 80}{RESET}\n")


def phase_1_create_session():
    """Phase 1: Create a new session."""
    print_section("PHASE 1: Starting Session")

    print(f"{CYAN}{ARROW} Connecting to HOPE backend...{RESET}")
    time.sleep(0.5)

    try:
        response = requests.post(f"{API_BASE}/sessions", timeout=30)
        response.raise_for_status()
        session = response.json()

        session_id = session.get('session_id') or session.get('sessionId') or session.get('id')
        print(f"{GREEN}{CHECK} Session created successfully!{RESET}")
        print(f"{BOLD}  Session ID:{RESET} {YELLOW}{session_id}{RESET}\n")

        return session_id
    except Exception as e:
        print(f"{RED}{CROSS} Failed to create session: {e}{RESET}")
        sys.exit(1)


def phase_questionnaire(session_id):
    """10-question daily check-in — runs AFTER assessment, BEFORE exercise.

    Matches the schema the app sends (see
    flutter_app/lib/screens/patient/questionnaire_screen.dart:18-39).
    The app is the source of truth for these keys and shapes.
    """
    print_section("DAILY CHECK-IN: Questionnaire")

    print(f"{CYAN}{ARROW} Patient filling out daily check-in...{RESET}")
    animate_dots("Processing responses", duration=2.0)

    questionnaire = {
        "sleep_hours": 7.5,
        "body_temperature": 37.0,
        "blood_sugar": 100,
        "blood_pressure": {"systolic": 120, "diastolic": 80},
        "headache": False,
        "dizzy": False,
        "fatigue": True,
        "arm_pain": 3,
        "hand_movement": True,
        "falls_injuries": False,
    }

    try:
        response = requests.put(
            f"{API_BASE}/sessions/{session_id}/questionnaire",
            json=questionnaire,
            timeout=30
        )
        response.raise_for_status()
        print(f"{GREEN}{CHECK} Questionnaire submitted successfully!{RESET}")
        bp = questionnaire['blood_pressure']
        print(f"{DIM}  Sleep: {questionnaire['sleep_hours']}h | Temp: {questionnaire['body_temperature']}°C | BP: {bp['systolic']}/{bp['diastolic']} | Arm pain: {questionnaire['arm_pain']}/10{RESET}\n")
        return True
    except Exception as e:
        print(f"{RED}{CROSS} Failed to submit questionnaire: {e}{RESET}")
        return False


def phase_2b_link_device(session_id):
    """Phase 2.5: Link the HOPE glove device to this session."""
    print_section("PHASE 2.5: Device Linking")

    print(f"{CYAN}{ARROW} Linking HOPE glove to session...{RESET}")
    time.sleep(0.5)

    try:
        response = requests.put(
            f"{API_BASE}/sessions/{session_id}/device",
            json={"device_id": DEVICE_ID},
            timeout=30
        )
        response.raise_for_status()
        result = response.json()

        print(f"{GREEN}{CHECK} Device linked successfully!{RESET}")
        print(f"{DIM}  Device ID: {DEVICE_ID}{RESET}")
        print(f"{DIM}  Status: {result.get('status', 'linked')}{RESET}\n")
        return True
    except Exception as e:
        print(f"{RED}{CROSS} Failed to link device: {e}{RESET}")
        return False


def phase_3_assessment(session_id):
    """Phase 3: Assessment with sensor data."""
    print_section("PHASE 3: Glove Assessment")

    blink_text("Connect HOPE glove and prepare for assessment...", blinks=4)

    print(f"{CYAN}{ARROW} Collecting sensor data...{RESET}")
    time.sleep(0.5)

    # Generate realistic sensor data
    sensor_data = generate_assessment_data(100)

    # Show live sensor feed
    print_sensor_feed(sensor_data)

    print(f"{CYAN}{ARROW} Sending assessment data to AI via /ingest...{RESET}")
    spinner("Analyzing movement patterns", duration=2.5, check_done=True)

    try:
        # The glove sends only device_id + data. The backend determines the phase
        # from the session's current status — the glove never needs to know.
        response = requests.post(
            f"{API_BASE}/ingest",
            json={
                "device_id": DEVICE_ID,
                "data": sensor_data
            },
            timeout=30
        )
        response.raise_for_status()
        results = response.json()

        # Display results
        print(f"\n{BOLD}{GREEN}{CHECK} Assessment Complete!{RESET}\n")

        if 'assessment_results' in results:
            ar = results['assessment_results']

            # Show pass/fail indicators
            print(f"{BOLD}  Assessment Scores:{RESET}")
            for task, passed in ar.items():
                if task == 'needed_training':
                    continue
                if isinstance(passed, bool):
                    status = f"{GREEN}PASS{RESET}" if passed else f"{RED}FAIL{RESET}"
                    print(f"    {BULLET} {task}: {status}")

            if 'needed_training' in results:
                print(f"\n  {BOLD}Recommended Exercises:{RESET}")
                for ex in results['needed_training']:
                    print(f"    {YELLOW}{BULLET}{RESET} {ex.replace('_', ' ').title()}")

        return results
    except Exception as e:
        print(f"{RED}{CROSS} Assessment failed: {e}{RESET}")
        return None


def phase_4_poll_results(session_id):
    """Phase 4: Poll for results."""
    print_section("PHASE 4: Retrieving Results")

    print(f"{CYAN}{ARROW} App polling for assessment results...{RESET}\n")

    max_polls = 4
    for i in range(1, max_polls + 1):
        spinner(f"Polling server (attempt {i}/{max_polls})", duration=2.5)

        try:
            response = requests.get(f"{API_BASE}/sessions/{session_id}", timeout=30)
            response.raise_for_status()
            session = response.json()

            if 'assessment_results' in session and session['assessment_results']:
                print(f"\n{GREEN}{CHECK} Results received!{RESET}\n")

                # Display in a nice box
                ar = session['assessment_results']
                lines = []

                # Show per-task PASS/FAIL results
                task_results = {k: v for k, v in ar.items() if k != 'needed_training'}
                if task_results:
                    passed = sum(1 for v in task_results.values() if v == 'PASS')
                    total = len(task_results)
                    lines.append(f"Tasks Passed: {BOLD}{passed}/{total}{RESET}")
                    for task, result in task_results.items():
                        color = GREEN if result == 'PASS' else RED
                        lines.append(f"  {BULLET} {task}: {color}{result}{RESET}")

                if 'needed_training' in ar and ar['needed_training']:
                    lines.append("")
                    lines.append(f"{BOLD}Training Focus:{RESET}")
                    for ex in ar['needed_training']:
                        lines.append(f"  {ARROW} {ex.replace('_', ' ').title()}")

                if lines:
                    print_box("Assessment Results", lines, color=GREEN)

                return session
        except Exception as e:
            print(f"{YELLOW}  Warning: Poll failed: {e}{RESET}")

    print(f"{RED}{CROSS} Could not retrieve results after {max_polls} attempts{RESET}")
    return None


def phase_5_exercise(session_id, session_data):
    """Phase 5: Perform exercises."""
    print_section("PHASE 5: Exercise Training")

    # Get needed training exercises
    needed_training = []
    if session_data and 'assessment_results' in session_data:
        ar = session_data['assessment_results']
        if 'needed_training' in ar:
            needed_training = ar['needed_training']

    if not needed_training:
        needed_training = ["grip_strength", "finger_extension"]

    # Perform first exercise
    exercise = needed_training[0]
    exercise_name = exercise.replace('_', ' ').title()

    print(f"{CYAN}{ARROW} Starting exercise: {BOLD}{exercise_name}{RESET}\n")
    time.sleep(0.5)

    # Show exercise timer
    print(f"{YELLOW}  Patient performing {exercise_name}...{RESET}")
    for i in range(10):
        bar = "█" * i + "░" * (10 - i)
        sys.stdout.write(f"\r  {CYAN}[{bar}]{RESET} {(i+1)*10}% - {i+1}0 reps")
        sys.stdout.flush()
        time.sleep(0.3)
    print(f"\n{GREEN}{CHECK} Exercise complete!{RESET}\n")

    # Generate and send exercise data
    print(f"{CYAN}{ARROW} Sending exercise data via /ingest...{RESET}")
    exercise_data = generate_exercise_data(exercise)

    # Retry up to 4 times against transient connection errors (Lambda cold
    # starts, CloudFront resets). The ingest router itself uses strongly
    # consistent reads, so DynamoDB consistency is not a concern — once the
    # assessment batch's response has returned, the next batch will see
    # assessment_results present and route to exercise.
    results = None
    for attempt in range(1, 5):
        try:
            response = requests.post(
                f"{API_BASE}/ingest",
                json={"device_id": DEVICE_ID, "data": exercise_data},
                timeout=30
            )
            response.raise_for_status()
            results = response.json()
            if 'exercise_results' in results:
                break  # Got exercise results — success
            # Unexpected: assessment ran again. Shouldn't happen with the
            # current router, but leave the retry as a safety net.
            if attempt < 4:
                print(f"{DIM}  (retry {attempt}/4 — unexpected assessment response){RESET}")
                time.sleep(3)
        except Exception as e:
            # Connection errors (cold start / reset) are retryable
            if attempt < 4:
                print(f"{DIM}  (retry {attempt}/4 after connection error: {e}){RESET}")
                time.sleep(3)
            else:
                print(f"{RED}{CROSS} Exercise submission failed: {e}{RESET}")
                return False

    if not results or 'exercise_results' not in results:
        print(f"{RED}{CROSS} Exercise phase did not complete after retries.{RESET}")
        return False

    # Show exercise results
    print(f"{GREEN}{CHECK} Exercise data processed!{RESET}\n")

    er = results['exercise_results']
    lines = []
    if 'overall_percent' in er:
        score = er['overall_percent']
        print_progress_bar(f"{exercise_name} Score", score)
        lines.append(er.get('message', ''))

    if 'features' in er:
        for feat, val in er['features'].items():
            lines.append(f"{feat.title()}: {val:.1f}%")

    if lines:
        print_box("Exercise Results", [l for l in lines if l], color=CYAN)

    return True


def phase_6_summary(session_id):
    """Phase 6: Session summary."""
    print_section("PHASE 6: Session Summary")

    print(f"{CYAN}{ARROW} Fetching complete session record...{RESET}")
    time.sleep(0.5)

    try:
        response = requests.get(f"{API_BASE}/sessions/{session_id}", timeout=30)
        response.raise_for_status()
        session = response.json()

        print(f"{GREEN}{CHECK} Session record retrieved!{RESET}\n")

        # Build summary table
        print(f"{BOLD}{MAGENTA}╔{'═' * 58}╗{RESET}")
        print(f"{BOLD}{MAGENTA}║{RESET} {BOLD}SESSION SUMMARY{' ' * 43}{RESET}{BOLD}{MAGENTA}║{RESET}")
        print(f"{BOLD}{MAGENTA}╠{'═' * 58}╣{RESET}")

        # Session info
        print(f"{BOLD}{MAGENTA}║{RESET} {DIM}Session ID:{RESET} {session_id:<44} {BOLD}{MAGENTA}║{RESET}")

        # Daily check-in questionnaire (10 canonical fields)
        q = session.get('questionnaire', {})
        if q:
            bp = q.get('blood_pressure') or {}
            print(f"{BOLD}{MAGENTA}╠{'═' * 58}╣{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET} {BOLD}Daily Check-In{RESET}{' ' * 44}{BOLD}{MAGENTA}║{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET}   Sleep: {q.get('sleep_hours', 'N/A')}h | Temp: {q.get('body_temperature', 'N/A')}°C | Sugar: {q.get('blood_sugar', 'N/A')} mg/dL{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET}   BP: {bp.get('systolic', 'N/A')}/{bp.get('diastolic', 'N/A')} | Arm pain: {q.get('arm_pain', 'N/A')}/10{RESET}")
            symptoms = [
                k for k in ('headache', 'dizzy', 'fatigue', 'falls_injuries') if q.get(k)
            ]
            if not q.get('hand_movement', True):
                symptoms.append('reduced hand movement')
            if symptoms:
                print(f"{BOLD}{MAGENTA}║{RESET}   Reported: {', '.join(symptoms)}{RESET}")

        # Assessment
        ar = session.get('assessment_results', {})
        if ar:
            task_results = {k: v for k, v in ar.items() if k != 'needed_training'}
            passed = sum(1 for v in task_results.values() if v == 'PASS')
            total = len(task_results)
            print(f"{BOLD}{MAGENTA}╠{'═' * 58}╣{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET} {BOLD}Assessment Results{RESET}{' ' * 40}{BOLD}{MAGENTA}║{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET}   Passed: {passed}/{total}")
            for task, result in task_results.items():
                color = GREEN if result == 'PASS' else RED
                print(f"{BOLD}{MAGENTA}║{RESET}   {BULLET} {task}: {color}{result}{RESET}")
            needed = ar.get('needed_training', [])
            if needed:
                training = ', '.join([t.replace('_', ' ').title() for t in needed[:3]])
                print(f"{BOLD}{MAGENTA}║{RESET}   Focus Areas: {training}")

        # Exercise
        er = session.get('exercise_results')
        if er:
            print(f"{BOLD}{MAGENTA}╠{'═' * 58}╣{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET} {BOLD}Exercise Results{RESET}{' ' * 41}{BOLD}{MAGENTA}║{RESET}")
            if 'exercise' in er:
                print(f"{BOLD}{MAGENTA}║{RESET}   Exercise: {er['exercise']}")
            if 'overall_percent' in er:
                print(f"{BOLD}{MAGENTA}║{RESET}   Score: {float(er['overall_percent']):.1f}%")
            if 'message' in er:
                print(f"{BOLD}{MAGENTA}║{RESET}   {er['message']}")
        else:
            print(f"{BOLD}{MAGENTA}╠{'═' * 58}╣{RESET}")
            print(f"{BOLD}{MAGENTA}║{RESET} {DIM}Exercise results not yet available{RESET}{' ' * 23}{BOLD}{MAGENTA}║{RESET}")

        print(f"{BOLD}{MAGENTA}╚{'═' * 58}╝{RESET}\n")

        # Final message
        print(f"{GREEN}{BOLD}{CHECK} Session completed successfully!{RESET}")
        print(f"{CYAN}  Thank you for using HOPE Smart Rehabilitation Glove{RESET}\n")

        return True
    except Exception as e:
        print(f"{RED}{CROSS} Failed to retrieve session: {e}{RESET}")
        return False


def main():
    """Run the full demo simulation."""
    # Print banner
    print_banner()

    # Phase 1: Create session
    session_id = phase_1_create_session()
    time.sleep(1)

    # Phase 2: Link device (happens before assessment in the real app flow)
    if not phase_2b_link_device(session_id):
        print(f"{RED}Demo stopped due to device linking error.{RESET}")
        sys.exit(1)
    time.sleep(1)

    # Phase 3: Assessment
    assessment_results = phase_3_assessment(session_id)
    if not assessment_results:
        print(f"{RED}Demo stopped due to assessment error.{RESET}")
        sys.exit(1)
    # Wait for DynamoDB write to propagate before subsequent reads
    time.sleep(3)

    # Phase 4: Poll results (patient views assessment PASS/FAIL)
    session_data = phase_4_poll_results(session_id)
    time.sleep(1)

    # Phase 5: Daily check-in questionnaire (optional in the app; always submitted here for demo coverage)
    if not phase_questionnaire(session_id):
        print(f"{YELLOW}Questionnaire submission failed; continuing anyway.{RESET}")
    time.sleep(1)

    # Phase 6: Exercise
    phase_5_exercise(session_id, session_data)
    time.sleep(1)

    # Phase 7: Summary
    phase_6_summary(session_id)

    print(f"\n{BOLD}{GREEN}{'═' * 60}{RESET}")
    print(f"{BOLD}{GREEN}  Demo Complete! Thank you for trying HOPE!{RESET}")
    print(f"{BOLD}{GREEN}{'═' * 60}{RESET}\n")


if __name__ == "__main__":
    main()
