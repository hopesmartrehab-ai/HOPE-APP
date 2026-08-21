"""Shared pytest configuration."""
import os
import sys

# Add lambda directories to path so handlers can import their siblings (assess_logic, etc.)
LAMBDAS_ROOT = os.path.join(os.path.dirname(__file__), '..', 'lambdas')

for lambda_dir in ('hope_session_api', 'hope_ingest'):
    path = os.path.join(LAMBDAS_ROOT, lambda_dir)
    if path not in sys.path:
        sys.path.insert(0, path)
