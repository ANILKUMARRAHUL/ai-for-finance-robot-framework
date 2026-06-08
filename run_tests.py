import os
import sys
import subprocess
from pathlib import Path

BASE_REPORT_DIR = "Reports"

def run_robot(test_path=None, test_name=None):
    os.makedirs(BASE_REPORT_DIR, exist_ok=True)

    # Run all tests
    if test_path in [None, "all"]:
        output_dir = os.path.join(BASE_REPORT_DIR, "all_tests")

        command = [
            "robot",
            "-v", "HEADLESS:False",
            "-d", output_dir,
            "Testcases"
        ]

    # Run specific .robot file or testcase
    else:
        suite_name = Path(test_path).stem
        output_dir = os.path.join(BASE_REPORT_DIR, suite_name)

        command = [
            "robot",
            "-v", "HEADLESS:False",
            "-d", output_dir
        ]

        # Add testcase filter if provided
        if test_name:
            command.extend(["-t", test_name])

        command.append(test_path)

    print(f"\nRunning results in: {output_dir}\n")
    print("Command:", " ".join(command))

    subprocess.run(command)


if __name__ == "__main__":

    # Run all tests
    if len(sys.argv) == 1:
        run_robot("all")

    # Run robot file
    elif len(sys.argv) == 2:
        run_robot(sys.argv[1])

    # Run specific testcase
    elif len(sys.argv) == 3:
        run_robot(sys.argv[2], sys.argv[1])

    else:
        print("Usage:")
        print("python run_tests.py")
        print("python run_tests.py <robot_file>")
        print('python run_tests.py "<test_name>" "<robot_file>"')