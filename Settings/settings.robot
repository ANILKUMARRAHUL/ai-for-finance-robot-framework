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
    Go To    ${BASE_URL}
    Run Keyword If    not ${HEADLESS}    Maximize Browser Window
    Set Selenium Timeout    20s
# Open Browser With Options
#     ${options}=    Evaluate
#     ...    (lambda opts: [opts.add_argument("--headless=new") if ${HEADLESS} else None, opts.add_argument("--window-size=1920,1080"), opts.add_argument("--force-device-scale-factor=0.80"), opts.add_argument("--disable-gpu"), opts.add_argument("--no-sandbox"), opts.add_argument("--disable-dev-shm-usage"), opts][-1])(sys.modules['selenium.webdriver'].ChromeOptions())
#     ...    sys, selenium.webdriver
#     Create WebDriver    Chrome    options=${options}

#     ${clean_base_url}=    Remove String Using Regexp    ${BASE_URL}    /+$    ${EMPTY}

#     ${access_token}=          Get Variable Value    ${ACCESS_TOKEN}          ${EMPTY}
#     ${refresh_token}=         Get Variable Value    ${REFRESH_TOKEN}         ${EMPTY}
#     ${user_json_b64}=         Get Variable Value    ${USER_JSON_B64}         ${EMPTY}
#     ${user_access_json_b64}=  Get Variable Value    ${USER_ACCESS_JSON_B64}  ${EMPTY}

#     IF    '${access_token}' != '${EMPTY}' and '${refresh_token}' != '${EMPTY}'
#         Go To    ${clean_base_url}

#         Add Cookie    access_token    ${access_token}    path=/
#         Add Cookie    refresh_token    ${refresh_token}    path=/

#         IF    '${user_json_b64}' != '${EMPTY}'
#             ${user_json}=    Evaluate    __import__('base64').b64decode('''${user_json_b64}''').decode('utf-8')
#             Execute Javascript    localStorage.setItem('user', arguments[0]);    ARGUMENTS    ${user_json}
#         END

#         IF    '${user_access_json_b64}' != '${EMPTY}'
#             ${user_access_json}=    Evaluate    __import__('base64').b64decode('''${user_access_json_b64}''').decode('utf-8')
#             Execute Javascript    localStorage.setItem('user_access', arguments[0]);    ARGUMENTS    ${user_access_json}
#         END

#         Go To    ${clean_base_url}/invoice-check/dashboard?date_preset=month_till_date&date_column=voucher_date

#         Wait Until Keyword Succeeds    20x    1s
#         ...    Element Should Be Visible    ${DASHBOARD_HEADING}

#         Capture Page Screenshot    after_cookie_login.png
#     ELSE
#         Go To    ${clean_base_url}
#     END

#     Run Keyword If    not ${HEADLESS}    Maximize Browser Window
#     Set Selenium Timeout    20s

Terminate Browser Session
    Close Browser
