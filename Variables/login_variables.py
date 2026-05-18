import os
from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

BASE_URL = os.getenv("BASE_URL")
BROWSER = os.getenv("BROWSER")
TIMEOUT = int(os.getenv("TIMEOUT", "30")) if str(os.getenv("TIMEOUT", "30")).isdigit() else 30
VALID_USERNAME = os.getenv("VALID_USERNAME")
VALID_NON_PO_USERNAME = os.getenv("VALID_NON_PO_USERNAME")
VALID_PASSWORD = os.getenv("VALID_PASSWORD")
INVALID_USERNAME = os.getenv("INVALID_USERNAME")
INVALID_PASSWORD = os.getenv("INVALID_PASSWORD")