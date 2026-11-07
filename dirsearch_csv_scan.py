
import subprocess
import shlex
import sys
from pathlib import Path

# Dirsearch Scanner - Python
# Usage: python dirsearch_scan.py

target = input("Enter target IP or URL: ").strip()
report = input("Enter report filename (e.g., target_report.csv): ").strip()
flags = input("Enter flags: ").strip()

# Validate input
if not target:
    print("Error: Target cannot be empty.")
    sys.exit(1)

if not report:
    print("Error: Report filename cannot be empty.")
    sys.exit(1)

# Add .csv extension if missing
if not report.lower().endswith(".csv"):
    report += ".csv"

# Build command
command = [
    sys.executable,
    "dirsearch.py",
    "-u", target,
    *shlex.split(flags),
    "--output-formats=csv",
    f"--output-file={report}",
]

print("\nRunning Dirsearch...")
print(f"Target: {target}")
print(f"Report: {report}")

try:
    result = subprocess.run(command, check=False)

    if result.returncode == 0:
        print(f"\nScan completed. Report saved to: {report}")
    else:
        print(f"\nDirsearch exited with code: {result.returncode}")

except FileNotFoundError:
    print("Error: Python or dirsearch.py was not found.")
    sys.exit(1)
