*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    DateTime
Variables    ../Variables/invoice_check_variables.py

*** Keywords ***
# Open Invoice Check Module
#     Wait Until Page Contains Element    xpath=//a[contains(@href,'/invoice-check/')]    20s
#     Click Element    xpath=//a[contains(@href,'/invoice-check/')]

Go To Dashboard Page
    Wait Until Element Is Visible    ${SIDENAV_DASHBOARD}    20s
    Click Element    ${SIDENAV_DASHBOARD}

Verify Dashboard Page
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible    ${DASHBOARD_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Go To Reports Page
    Wait Until Element Is Visible    ${SIDENAV_REPORTS}    20s
    Click Element    ${SIDENAV_REPORTS}

Verify Reports Page
    Wait Until Location Contains    /invoice-check/reports    20s
    Wait Until Element Is Visible    ${REPORTS_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Go To Downloads Page
    Wait Until Element Is Visible    ${SIDENAV_DOWNLOADS}    20s
    Click Element    ${SIDENAV_DOWNLOADS}

Verify Downloads Page
    Wait Until Location Contains    /invoice-check/downloads    20s
    Wait Until Element Is Visible    ${DOWNLOADS_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Slow Scroll To Bottom
    ${height}=    Execute JavaScript    return document.body.scrollHeight
    FOR    ${i}    IN RANGE    0    ${height}    400
        Execute JavaScript    window.scrollTo(0, ${i})
        Sleep    0.4s
    END
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Wait For Page To Stabilize
    Sleep    5s

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}
    
Validate Dashboard KPI Cards With Reports Count
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]//div[contains(@class,'uppercase')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        Log To Console    \nChecking card: ${title}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}'
            Log To Console    Skipping card: ${title}
            CONTINUE
        END

        # Step 1 — Scroll to card and hover
        Scroll Element Into View    ${click_card}
        Sleep    1s
        Mouse Over    ${click_card}
        Sleep    2s

        # Step 2 — Take screenshot to see what tooltip looks like
        Capture Page Screenshot    tooltip_${position}.png

        # Step 3 — Read tooltip text — try different possible tooltip xpaths
        ${tooltip_visible}=    Run Keyword And Return Status
        ...    Element Should Be Visible    xpath=//*[contains(text(),'Exact Value')]
        Log To Console    Tooltip visible: ${tooltip_visible}

        IF    ${tooltip_visible}
            ${tooltip_text}=    Get Text    xpath=//*[contains(text(),'Exact Value')]
            Log To Console    Tooltip text: ${tooltip_text}
            ${exact_value}=     Fetch From Right    ${tooltip_text}    :
            ${exact_value}=     Strip String        ${exact_value}
            ${dashboard_count}=    Clean Number Text    ${exact_value}
        ELSE
            # Fallback — read abbreviated value if tooltip not visible
            ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]//div[contains(@class,'text-4xl')]
            ${value}=            Get Text    ${value_locator}
            ${dashboard_count}=    Clean Number Text    ${value}
            Log To Console    Tooltip not found — using card value: ${dashboard_count}
        END

        Log To Console    Dashboard count: ${dashboard_count}

        # Step 4 — Click the card
        Click Element    ${click_card}

        Wait Until Location Contains    /invoice-check/reports    20s
        Wait Until Element Is Visible   ${REPORTS_BOTTOM_TOTAL}    20s

        Slow Scroll To Bottom

        ${reports_total}=    Get Text    ${REPORTS_BOTTOM_TOTAL}
        ${reports_count}=    Clean Number Text    ${reports_total}

        Log To Console    Reports total: ${reports_count}

        Should Be Equal    ${dashboard_count}    ${reports_count}

        Go Back
        Wait Until Location Contains    /invoice-check/dashboard    20s
        Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
        Scroll To Top
        Wait For Page To Stabilize
    END

Scroll To Reconciliation Table
    Wait Until Element Is Visible    ${RECON_TABLE_HEADING}    20s
    Scroll Element Into View         ${RECON_TABLE_HEADING}
    Sleep    2s

Open View By Dropdown
    Wait Until Element Is Visible    ${VIEW_BY_DROPDOWN}    20s
    Scroll Element Into View         ${VIEW_BY_DROPDOWN}
    Sleep    1s
    Click Element                    ${VIEW_BY_DROPDOWN}
    Sleep    2s

Select View By Option
    [Arguments]    ${option_locator}

    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    2s

Get Reconciliation Column Header
    Wait Until Element Is Visible    ${RECON_DYNAMIC_COLUMN_HEADER}    20s
    ${header}=    Get Text    ${RECON_DYNAMIC_COLUMN_HEADER}
    Log To Console    \nColumn Header: ${header}
    RETURN    ${header}

Validate View By Filter Change
    [Arguments]    ${filter_name}    ${option_locator}    ${expected_keyword}

    Log To Console    \n--- Checking Filter: ${filter_name} ---

    Open View By Dropdown
    Select View By Option    ${option_locator}

    ${header}=    Get Reconciliation Column Header

    Should Contain    ${header}    ${expected_keyword}

Validate Reconciliation View By Filters
    Scroll To Reconciliation Table
    Validate View By Filter Change    Month      ${VIEW_BY_MONTH_OPTION}      (
    Validate View By Filter Change    Quarter    ${VIEW_BY_QUARTER_OPTION}    Q
    Validate View By Filter Change    Year       ${VIEW_BY_YEAR_OPTION}       20

Select Date Column Filter
    [Arguments]    ${option_locator}
    Wait Until Element Is Visible    ${DATE_COLUMN_DROPDOWN}    20s
    Scroll Element Into View         ${DATE_COLUMN_DROPDOWN}
    Click Element                    ${DATE_COLUMN_DROPDOWN}
    Sleep    3s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Select Date Range Filter
    [Arguments]    ${option_locator}
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s
    Wait Until Element Is Visible    ${DATE_RANGE_DROPDOWN}    20s
    Click Element                    ${DATE_RANGE_DROPDOWN}
    Sleep    2s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Click First Available KPI Card
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    45s
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]//div[contains(@class,'uppercase')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}'
            Log To Console    Skipping card: ${title}
            CONTINUE
        END

        Log To Console    Clicking card: ${title}
        Scroll Element Into View    ${click_card}
        Sleep    1s
        Click Element    ${click_card}
        BREAK
    END

Verify Reports Page URL Contains Filters
    [Arguments]    ${expected_date_column}    ${expected_date_preset}
    Wait Until Location Contains    /invoice-check/reports    20s
    Wait Until Element Is Visible   ${REPORTS_HEADING}        20s
    Sleep    2s
    ${current_url}=    Get Location
    Log To Console    \nCurrent URL: ${current_url}
    Should Contain    ${current_url}    ${expected_date_column}
    Should Contain    ${current_url}    ${expected_date_preset}
    Log To Console    URL contains expected filters: ${expected_date_column} | ${expected_date_preset}

Validate Dashboard Filter Combination
    [Arguments]    ${date_column_option}    ${date_range_option}    ${expected_date_column}    ${expected_date_preset}
    Log To Console    \n--- Testing: ${expected_date_column} + ${expected_date_preset} ---

    Select Date Column Filter    ${date_column_option}
    Select Date Range Filter     ${date_range_option}

    Wait For Page To Stabilize

    Click First Available KPI Card

    Verify Reports Page URL Contains Filters    ${expected_date_column}    ${expected_date_preset}

    Go Back
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
    Scroll To Top
    Wait For Page To Stabilize

Validate All Dashboard Filter Combinations
    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_MONTH_TILL_DATE}
    ...    date_column=invoice_date       date_preset=month_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_YEAR_TILL_DATE}
    ...    date_column=invoice_date       date_preset=year_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=invoice_date       date_preset=last_month

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_FISCAL_YEAR}
    ...    date_column=invoice_date       date_preset=fiscal_year

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_MONTH_TILL_DATE}
    ...    date_column=voucher_date       date_preset=month_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_YEAR_TILL_DATE}
    ...    date_column=voucher_date       date_preset=year_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=voucher_date       date_preset=last_month

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_FISCAL_YEAR}
    ...    date_column=voucher_date       date_preset=fiscal_year

Get Random Start And End Date
    ${today}=                   Get Current Date    result_format=%Y-%m-%d
    ${today_dt}=                Convert Date        ${today}    datetime
    ${current_day}=             Set Variable        ${today_dt.day}
    ${current_month}=           Set Variable        ${today_dt.month}
    ${current_year}=            Set Variable        ${today_dt.year}

    # Random number of months to go back (6 to 10)
    ${months_back}=             Evaluate    random.randint(6, 10)    modules=random

    # Calculate start month and year
    ${total_start_month}=       Evaluate    ${current_month} - ${months_back}
    ${start_year}=              Evaluate    ${current_year} if ${total_start_month} > 0 else ${current_year} - 1
    ${start_month}=             Evaluate    ${total_start_month} if ${total_start_month} > 0 else ${total_start_month} + 12

    # Get max days in start month to pick valid random day
    ${max_start_day}=           Evaluate    calendar.monthrange(${start_year}, ${start_month})[1]    modules=calendar
    ${start_day}=               Evaluate    random.randint(1, ${max_start_day})    modules=random

    # Random number of months after start month for end month (1 to months_back)
    ${months_forward}=          Evaluate    random.randint(1, ${months_back})    modules=random
    ${total_end_month}=         Evaluate    ${start_month} + ${months_forward}
    ${end_year}=                Evaluate    ${start_year} if ${total_end_month} <= 12 else ${start_year} + 1
    ${end_month}=               Evaluate    ${total_end_month} if ${total_end_month} <= 12 else ${total_end_month} - 12

    # Make sure end month does not exceed current month
    ${end_month}=               Evaluate    ${current_month} if (${end_year} == ${current_year} and ${end_month} > ${current_month}) else ${end_month}
    ${end_year}=                Evaluate    ${current_year} if ${end_year} > ${current_year} else ${end_year}

    # Get max days in end month — if end is current month, cap at today
    ${max_end_day}=             Evaluate    calendar.monthrange(${end_year}, ${end_month})[1]    modules=calendar
    ${max_end_day}=             Evaluate    ${current_day} if (${end_year} == ${current_year} and ${end_month} == ${current_month}) else ${max_end_day}
    ${end_day}=                 Evaluate    random.randint(1, ${max_end_day})    modules=random

    # Format for URL verification (YYYY-MM-DD)
    ${start_month_padded}=      Evaluate    str(${start_month}).zfill(2)
    ${end_month_padded}=        Evaluate    str(${end_month}).zfill(2)
    ${start_day_padded}=        Evaluate    str(${start_day}).zfill(2)
    ${end_day_padded}=          Evaluate    str(${end_day}).zfill(2)

    ${from_date}=               Set Variable    ${start_year}-${start_month_padded}-${start_day_padded}
    ${to_date}=                 Set Variable    ${end_year}-${end_month_padded}-${end_day_padded}

    # Format for data-day attribute (M/D/YYYY) — no zero padding
    ${start_data_day}=          Set Variable    ${start_month}/${start_day}/${start_year}
    ${end_data_day}=            Set Variable    ${end_month}/${end_day}/${end_year}

    # Calculate how many times to click left arrow from current month to reach start month
    ${clicks_needed}=           Evaluate    (${current_year} - ${start_year}) * 12 + (${current_month} - ${start_month})

    # Calculate how many times to click right arrow from start month to reach end month
    ${right_clicks_needed}=     Evaluate    (${end_year} - ${start_year}) * 12 + (${end_month} - ${start_month})

    Log To Console              \nMonths back: ${months_back} | Start: ${from_date} | End: ${to_date}
    Log To Console              Left arrow clicks: ${clicks_needed} | Right arrow clicks: ${right_clicks_needed}

    RETURN    ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

Select Custom Date Range
    [Arguments]    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

    ${prev_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Previous Month']
    ${next_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Next Month']

    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s

    # Wait for calendar to be present in DOM — not visibility check
    Wait Until Page Contains Element    ${prev_arrow}    30s
    Sleep    1s

    # Click left arrow using JS to bypass visibility issues in headless
    FOR    ${i}    IN RANGE    ${clicks_needed}
        Wait Until Page Contains Element    ${prev_arrow}    10s
        ${arrow}=    Get WebElement    ${prev_arrow}
        Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
        Sleep    1s
    END

    # Pick start date
    ${start_locator}=    Set Variable    xpath=//button[@data-day='${start_data_day}']
    Wait Until Page Contains Element    ${start_locator}    10s
    ${start_btn}=    Get WebElement    ${start_locator}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${start_btn}
    Sleep    1s

    # Click right arrow using JS
    FOR    ${i}    IN RANGE    ${right_clicks_needed}
        Wait Until Page Contains Element    ${next_arrow}    10s
        ${arrow}=    Get WebElement    ${next_arrow}
        Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
        Sleep    1s
    END

    # Pick end date
    ${end_locator}=    Set Variable    xpath=//button[@data-day='${end_data_day}']
    Wait Until Page Contains Element    ${end_locator}    10s
    ${end_btn}=    Get WebElement    ${end_locator}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${end_btn}
    Sleep    1s

    # Click apply
    Wait Until Page Contains Element    ${CUSTOM_RANGE_APPLY_BUTTON}    10s
    ${apply_btn}=    Get WebElement    ${CUSTOM_RANGE_APPLY_BUTTON}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${apply_btn}
    Sleep    3s

Validate Custom Range Filter Combination
    [Arguments]    ${date_column_option}    ${expected_date_column}

    Log To Console    \n--- Testing Custom Range: ${expected_date_column} ---

    ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}=
    ...    Get Random Start And End Date

    Select Date Column Filter       ${date_column_option}
    Select Date Range Filter        ${DATE_RANGE_CUSTOM_RANGE}
    Sleep    2s

    Select Custom Date Range        ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

    Wait For Page To Stabilize

    # Check if no data available for selected range
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo data available for selected range: ${from_date} to ${to_date} — skipping
        RETURN
    END

    Click First Available KPI Card

    Wait Until Location Contains    /invoice-check/reports    20s
    Wait Until Element Is Visible   ${REPORTS_HEADING}        20s
    Sleep    2s

    ${current_url}=    Get Location
    Log To Console    \nCurrent URL: ${current_url}

    Should Contain    ${current_url}    ${expected_date_column}
    Should Contain    ${current_url}    date_preset=custom_range
    Should Contain    ${current_url}    from=${from_date}
    Should Contain    ${current_url}    to=${to_date}

    Log To Console    URL verified for custom range: ${from_date} to ${to_date}

    Go Back
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
    Scroll To Top
    Wait For Page To Stabilize

Validate All Custom Range Filter Combinations
    Validate Custom Range Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}
    ...    date_column=invoice_date

    Validate Custom Range Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}
    ...    date_column=voucher_date

