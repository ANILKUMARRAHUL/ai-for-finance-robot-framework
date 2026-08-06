*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables    ../Variables/login_variables.py
Variables    ../Variables/invoice_check_variables.py
Variables    ../Variables/report_variables.py
Variables    ../Variables/download_variables.py
Variables    ../Variables/non_po_invoice_check_variables.py

*** Variables ***
${HEADLESS}    True

*** Keywords ***
Open Browser With Options
    ${options}=    Evaluate
    ...    (lambda opts: [opts.add_argument("--headless=new") if ${HEADLESS} else None, opts.add_argument("--window-size=1920,1080"), opts.add_argument("--force-device-scale-factor=0.80"), opts.add_argument("--disable-gpu"), opts.add_argument("--no-sandbox"), opts.add_argument("--disable-dev-shm-usage"), opts][-1])(sys.modules['selenium.webdriver'].ChromeOptions())
    ...    sys, selenium.webdriver
    Create WebDriver    Chrome    options=${options}

    ${access_token}=     Get Variable Value    ${ACCESS_TOKEN}    ${EMPTY}
    ${refresh_token}=    Get Variable Value    ${REFRESH_TOKEN}    ${EMPTY}

    IF    '${access_token}' != '${EMPTY}' and '${refresh_token}' != '${EMPTY}'
        Go To    ${BASE_URL}
        Add Cookie    access_token    ${access_token}    domain=20.235.55.214    path=/
        Add Cookie    refresh_token    ${refresh_token}    domain=20.235.55.214    path=/
        Go To    ${BASE_URL}/non-po/dashboard?date_preset=month_till_date&date_column=created_on
        Sleep    3s
        Capture Page Screenshot    after_cookie_login.png
    ELSE
        Go To    ${BASE_URL}
    END

    Run Keyword If    not ${HEADLESS}    Maximize Browser Window
    Set Selenium Timeout    20s

Terminate Browser Session
    Close Browser
