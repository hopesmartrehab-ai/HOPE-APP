"""Level 1 tests — exercise_logic.py (no AWS, no HTTP)."""
import math
import sys
import os
import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../lambdas/hope_ingest'))
from exercise_logic import run_exercise


def make_sample(time, ax=0.5, ay=0.1, az=0.1, gx=5.0, gy=0.0, gz=0.0,
                flex1=70, flex2=70, fsr1=80, fsr2=80, emg=50):
    return {"time": time, "ax": ax, "ay": ay, "az": az,
            "gx": gx, "gy": gy, "gz": gz,
            "flex1": flex1, "flex2": flex2, "fsr1": fsr1, "fsr2": fsr2, "emg": emg}


def grasp_data():
    return [make_sample(i * 50, flex1=70, flex2=70, fsr1=80, fsr2=80) for i in range(20)]


def reach_data():
    return [
        make_sample(i * 50,
                    ax=1.5 + 0.5 * math.sin(i * 0.3),
                    ay=0.2 + 0.1 * math.cos(i * 0.3),
                    gx=70.0)
        for i in range(20)
    ]


class TestRunExerciseGrasp:
    def test_returns_dict_with_required_keys(self):
        result = run_exercise(grasp_data(), "Grasp")
        assert "exercise" in result
        assert "overall_percent" in result
        assert "message" in result
        assert "features" in result
        assert "timestamp" in result

    def test_exercise_name_in_result(self):
        result = run_exercise(grasp_data(), "Grasp")
        assert result["exercise"] == "Grasp"

    def test_overall_percent_in_range(self):
        result = run_exercise(grasp_data(), "Grasp")
        assert 0 <= result["overall_percent"] <= 100

    def test_features_contain_force_and_flex(self):
        result = run_exercise(grasp_data(), "Grasp")
        assert "force" in result["features"]
        assert "flex" in result["features"]

    def test_high_force_flex_gives_good_score(self):
        # fsr1=fsr2=80, flex1=flex2=70 -> force=80, flex=70 -> overall=75
        result = run_exercise(grasp_data(), "Grasp")
        assert result["overall_percent"] == 75.0

    def test_message_is_string(self):
        result = run_exercise(grasp_data(), "Grasp")
        assert isinstance(result["message"], str)
        assert len(result["message"]) > 0


class TestRunExerciseReach:
    def test_returns_dict_with_required_keys(self):
        result = run_exercise(reach_data(), "Reach")
        assert "exercise" in result
        assert "overall_percent" in result
        assert "message" in result
        assert "features" in result

    def test_exercise_name_in_result(self):
        result = run_exercise(reach_data(), "Reach")
        assert result["exercise"] == "Reach"

    def test_features_contain_reach_keys(self):
        result = run_exercise(reach_data(), "Reach")
        assert "speed" in result["features"]
        assert "ROM" in result["features"]
        assert "trajectory" in result["features"]
        assert "deviation" in result["features"]

    def test_overall_percent_in_range(self):
        result = run_exercise(reach_data(), "Reach")
        assert 0 <= result["overall_percent"] <= 100


class TestRunExerciseEdgeCases:
    def test_empty_data_returns_error(self):
        result = run_exercise([], "Grasp")
        assert "error" in result
        assert "data" in result["error"].lower() or "enough" in result["error"].lower()

    def test_single_sample_returns_error(self):
        result = run_exercise([make_sample(0)], "Grasp")
        assert "error" in result

    def test_unknown_exercise_returns_error(self):
        result = run_exercise(grasp_data(), "FlyingKick")
        assert "error" in result

    def test_no_crash_on_empty_data(self):
        """Should return error dict, not raise an exception."""
        try:
            result = run_exercise([], "Grasp")
            assert isinstance(result, dict)
        except Exception as e:
            pytest.fail(f"run_exercise raised an exception on empty data: {e}")

    def test_manipulation_exercise(self):
        data = [make_sample(i * 50, ax=0.5 + 0.1 * math.sin(i * 0.3),
                            ay=0.1 + 0.05 * math.cos(i * 0.3)) for i in range(20)]
        result = run_exercise(data, "Manipulation")
        assert "error" not in result
        assert result["exercise"] == "Manipulation"
        assert "trajectory" in result["features"]
        assert "duration" in result["features"]

    def test_release_exercise(self):
        low_data = [make_sample(i * 50, flex1=5, flex2=5, fsr1=3, fsr2=3) for i in range(20)]
        result = run_exercise(low_data, "Release")
        assert "error" not in result
        assert result["exercise"] == "Release"
        assert "force" in result["features"]
        assert "flex" in result["features"]

    def test_motivational_messages(self):
        # High score (>90) -> "Great job"
        high_data = [make_sample(i * 50, flex1=95, flex2=95, fsr1=95, fsr2=95) for i in range(20)]
        result = run_exercise(high_data, "Grasp")
        assert "Great" in result["message"]

        # Low score (<50) -> "Keep trying"
        low_data = [make_sample(i * 50, flex1=5, flex2=5, fsr1=5, fsr2=5) for i in range(20)]
        result = run_exercise(low_data, "Grasp")
        assert "Keep" in result["message"] or "trying" in result["message"]
