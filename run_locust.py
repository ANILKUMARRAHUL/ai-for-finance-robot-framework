import os
import sys
import subprocess
from dotenv import load_dotenv

dotenv_path = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv(dotenv_path)


def main():

    print("=" * 60)
    print("LOCUST RUNNER")
    print("=" * 60)

    try:
        import locust
    except ImportError:
        print("Locust is not installed.")
        print("Install using:")
        print("pip install locust")
        sys.exit(1)

    base_url = os.getenv(
        "BASE_URL",
        "http://localhost:8000"
    )

    print(f"Target Host: {base_url}")
    print()
    print("Open:")
    print("http://localhost:8089")
    print()

    cmd = [
        sys.executable,
        "-m",
        "locust",
        "-f",
        "locustfile.py",
        "--host",
        base_url
    ]

    try:
        subprocess.run(cmd)

    except KeyboardInterrupt:
        print("\nStopped by user")

    except Exception as e:
        print(f"Failed: {e}")


if __name__ == "__main__":
    main()