import os
import sys
import subprocess
from dotenv import load_dotenv

# Load env variables from workspace .env file
dotenv_path = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv(dotenv_path)

def main():
    print("=" * 60)
    print("                      LOCUST RUNNER                      ")
    print("=" * 60)
    
    # Check if locust is installed
    try:
        import locust
    except ImportError:
        print("Locust is not installed in the current environment.")
        print("Please run: pip install locust")
        sys.exit(1)

    # Base URL configuration (from .env or custom)
    base_url = os.getenv("BASE_URL", "http://localhost:8000")
    
    print(f"Locust Configuration:")
    print(f"  Locustfile:  locustfile.py")
    print(f"  Target Host: {base_url}")
    print("-" * 60)
    print("Starting Locust server...")
    print("Open http://localhost:8089 in your browser to configure and start the load test.")
    print("Press Ctrl+C in this terminal to stop the Locust server.")
    print("=" * 60)

    # Launch locust with target host and file path
    cmd = [
        sys.executable,
        "-m",
        "locust",
        "-f", "locustfile.py",
        "--host", base_url
    ]
    
    try:
        # Run locust and forward output
        subprocess.run(cmd)
    except KeyboardInterrupt:
        print("\nLocust server terminated by user.")
    except Exception as e:
        print(f"Failed to start Locust: {e}")

if __name__ == "__main__":
    main()
