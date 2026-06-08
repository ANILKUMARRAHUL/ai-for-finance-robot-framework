import os
from locust import HttpUser, task, between
from dotenv import load_dotenv

# Load .env
dotenv_path = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv(dotenv_path)


class LoginUser(HttpUser):

    # Wait between requests
    wait_time = between(1, 3)

    @task
    def test_login(self):

        username = os.getenv("VALID_USERNAME", "dummy_user")
        password = os.getenv("VALID_PASSWORD", "dummy_password")

        payload = {
            "username": username,
            "password": password
        }

        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json"
        }

        print("=" * 80)
        print(f"USERNAME: {username}")
        print(f"HOST: {self.host}")
        print("REQUEST: POST /api/v1/account/login/")
        print("=" * 80)

        with self.client.post(
            "/api/v1/account/login/",
            json=payload,
            headers=headers,
            catch_response=True,
            name="POST /login"
        ) as response:

            print(f"STATUS CODE: {response.status_code}")

            try:
                print(f"RESPONSE: {response.text[:500]}")
            except Exception:
                pass

            if response.status_code == 200:
                print("SUCCESS")
                response.success()

            elif response.status_code == 401:
                print("FAILED: Unauthorized")
                response.failure(
                    f"401 Unauthorized. Response: {response.text[:200]}"
                )

            elif response.status_code == 404:
                print("FAILED: Endpoint Not Found")
                response.failure(
                    f"404 Not Found. Response: {response.text[:200]}"
                )

            elif response.status_code == 429:
                remaining = response.headers.get(
                    "X-RateLimit-Remaining",
                    "unknown"
                )

                print(
                    f"FAILED: Rate Limited. Remaining={remaining}"
                )

                response.failure(
                    f"429 Rate Limited. Remaining={remaining}"
                )

            elif response.status_code >= 500:
                print("FAILED: Server Error")

                response.failure(
                    f"{response.status_code} Server Error. "
                    f"Response: {response.text[:200]}"
                )

            else:
                print(
                    f"FAILED: HTTP {response.status_code}"
                )

                response.failure(
                    f"HTTP {response.status_code}. "
                    f"Response: {response.text[:200]}"
                )