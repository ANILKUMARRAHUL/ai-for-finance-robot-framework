*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables    ../Variables/login_variables.py
Variables    ../Variables/invoice_check_variables.py
Variables    ../Variables/report_variables.py
Variables    ../Variables/download_variables.py

*** Variables ***
${HEADLESS}    False

*** Keywords ***
Open Browser With Options
    ${options}=    Evaluate
    ...    (lambda opts: [opts.add_argument("--headless=new") if ${HEADLESS} else None, opts.add_argument("--window-size=1920,1080"), opts.add_argument("--disable-gpu"), opts.add_argument("--no-sandbox"), opts.add_argument("--disable-dev-shm-usage"), opts][-1])(sys.modules['selenium.webdriver'].ChromeOptions())
    ...    sys, selenium.webdriver

    Create WebDriver    Chrome    options=${options}
    Go To    ${BASE_URL}
    Maximize Browser Window
    Set Selenium Timeout    20s

Terminate Browser Session
    Close Browser