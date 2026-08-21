"""Level 1 tests — assess_logic.py (no AWS, no HTTP)."""
import math
import sys
import os
import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../lambdas/hope_ingest'))
from assess_logic import apply_filters, assess_session


def make_sample(time, ax=1.5, ay=0.2, az=0.2, gx=70.0, gy=0.0, gz=0.0,
                flex1=60, flex2=60, fsr1=70, fsr2=70, emg=50):
    return {"time": time, "ax": ax, "ay": ay, "az": az,
            "gx": gx, "gy": gy, "gz": gz,
            "flex1": flex1, "flex2": flex2, "fsr1": fsr1, "fsr2": fsr2, "emg": emg}


def good_data_grasp_pass():
    """20 samples that produce Reach+Grasp+Manipulation PASS, Release FAIL."""
    return [
        make_sample(i * 50,
                    ax=1.5 + 0.5 * math.sin(i * 0.3),
                    ay=0.2 + 0.1 * math.cos(i * 0.3),
                    gx=70.0, flex1=60, flex2=60, fsr1=70, fsr2=70)
        for i in range(20)
    ]


def good_data_release_pass():
    """20 samples that produce Reach+Manipulation+Release PASS, Grasp FAIL."""
    return [
        make_sample(i * 50,
                    ax=1.5 + 0.5 * math.sin(i * 0.3),
                    ay=0.2 + 0.1 * math.cos(i * 0.3),
                    gx=70.0, flex1=10, flex2=10, fsr1=5, fsr2=5)
        for i in range(20)
    ]


def bad_data():
    """20 samples that fail Reach, Grasp, Manipulation; pass Release."""
    return [make_sample(i * 50, ax=0.0, ay=0.0, az=0.0, gx=1.0,
                        flex1=5, flex2=5, fsr1=2, fsr2=2, emg=10)
            for i in range(20)]


class TestApplyFilters:
    def test_returns_same_length(self):
        data = [make_sample(i * 50) for i in range(10)]
        filtered = apply_filters(data)
        assert len(filtered) == len(data)

    def test_values_change_after_smoothing(self):
        # Create data with high-variance emg — low_pass should smooth it
        data = [make_sample(i * 50, emg=(100 if i % 2 == 0 else 0)) for i in range(10)]
        filtered = apply_filters(data)
        raw_emg = [d["emg"] for d in data]
        flt_emg = [d["emg"] for d in filtered]
        # Filtered values should not equal raw values for alternating signal
        assert flt_emg != raw_emg

    def test_empty_returns_empty(self):
        assert apply_filters([]) == []

    def test_preserves_time_field(self):
        data = [make_sample(i * 100) for i in range(5)]
        filtered = apply_filters(data)
        for orig, flt in zip(data, filtered):
            assert flt["time"] == orig["time"]

    def test_all_keys_present(self):
        data = [make_sample(i * 50) for i in range(5)]
        filtered = apply_filters(data)
        expected_keys = {"time", "flex1", "flex2", "fsr1", "fsr2", "emg",
                         "ax", "ay", "az", "gx", "gy", "gz"}
        for item in filtered:
            assert set(item.keys()) == expected_keys


class TestAssessSession:
    def test_good_data_reach_grasp_manipulation_pass(self):
        data = good_data_grasp_pass()
        result = assess_session(data)
        assert result["results"]["Reach"] is True
        assert result["results"]["Grasp"] is True
        assert result["results"]["Manipulation"] is True

    def test_good_data_grasp_pass_release_fails(self):
        """Grasp (force>50, flex>40) and Release (force<20, flex<20) are mutually exclusive."""
        data = good_data_grasp_pass()
        result = assess_session(data)
        assert result["results"]["Release"] is False
        assert "Release" in result["needed_training"]

    def test_good_data_release_pass(self):
        data = good_data_release_pass()
        result = assess_session(data)
        assert result["results"]["Reach"] is True
        assert result["results"]["Manipulation"] is True
        assert result["results"]["Release"] is True
        assert result["results"]["Grasp"] is False

    def test_bad_data_multiple_fails(self):
        data = bad_data()
        result = assess_session(data)
        assert result["results"]["Reach"] is False
        assert result["results"]["Grasp"] is False
        assert result["results"]["Manipulation"] is False

    def test_bad_data_needed_training_populated(self):
        data = bad_data()
        result = assess_session(data)
        assert len(result["needed_training"]) > 0
        assert "Reach" in result["needed_training"]
        assert "Grasp" in result["needed_training"]
        assert "Manipulation" in result["needed_training"]

    def test_return_structure(self):
        data = good_data_grasp_pass()
        result = assess_session(data)
        assert "results" in result
        assert "needed_training" in result
        assert "features" in result
        assert isinstance(result["results"], dict)
        assert isinstance(result["needed_training"], list)
        assert isinstance(result["features"], dict)

    def test_features_keys(self):
        data = good_data_grasp_pass()
        result = assess_session(data)
        expected = {"speed", "rom", "trajectory", "deviation", "flex", "force", "emg"}
        assert set(result["features"].keys()) == expected

    def test_results_keys(self):
        data = good_data_grasp_pass()
        result = assess_session(data)
        assert set(result["results"].keys()) == {"Reach", "Grasp", "Manipulation", "Release"}

    def test_needed_training_matches_failed_results(self):
        data = bad_data()
        result = assess_session(data)
        failed = [k for k, v in result["results"].items() if not v]
        assert sorted(result["needed_training"]) == sorted(failed)
