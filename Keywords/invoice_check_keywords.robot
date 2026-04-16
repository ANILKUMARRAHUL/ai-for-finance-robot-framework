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
    Wait Until Location Contains    /invoice-check/reports    40s
    Wait Until Element Is Visible    ${REPORTS_HEADING}    40s
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

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-2xl')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        Log To Console    \nChecking card: ${title}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}' or '${title}' == '${EXCLUDED_CARD_3}'
            Log To Console    Skipping card: ${title}
            CONTINUE
        END

        # Check if card value is 0 — skip if no data
        ${value}=           Get Text    ${value_locator}
        ${clean_value}=     Clean Number Text    ${value}
        IF    '${clean_value}' == '0'
            Log To Console    ${title} is 0, can't be clicked — skipping
            CONTINUE
        END

        # Hover to get exact value from tooltip
        Scroll Element Into View    ${click_card}
        Sleep    1s
        Mouse Over    ${click_card}
        Sleep    2s

        ${tooltip_visible}=    Run Keyword And Return Status
        ...    Element Should Be Visible    xpath=//*[contains(text(),'Exact Value')]

        IF    ${tooltip_visible}
            ${tooltip_text}=    Get Text    xpath=//*[contains(text(),'Exact Value')]
            Log To Console    Tooltip text: ${tooltip_text}
            ${exact_value}=     Fetch From Right    ${tooltip_text}    :
            ${exact_value}=     Strip String        ${exact_value}
            ${dashboard_count}=    Clean Number Text    ${exact_value}
        ELSE
            ${dashboard_count}=    Clean Number Text    ${value}
            Log To Console    Tooltip not found — using card value: ${dashboard_count}
        END

        Log To Console    Dashboard count: ${dashboard_count}

        Click Element    ${click_card}

        Wait Until Location Contains    /invoice-check/reports    40s
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

    # Check if no data available
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    No data available for filter: ${filter_name} — skipping header check
        RETURN
    END

    ${header}=    Get Reconciliation Column Header
    Should Contain    ${header}    ${expected_keyword}

Validate Reconciliation View By Filters
    Scroll To Reconciliation Table

    # Check if no data before even starting
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nReconciliation table has no data — skipping all View By filter checks
        RETURN
    END

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
    Wait For Dashboard Cards To Load
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-2xl')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}'
            Log To Console    Skipping card: ${title}
            CONTINUE
        END

        ${value}=           Get Text    ${value_locator}
        ${clean_value}=     Clean Number Text    ${value}
        IF    '${clean_value}' == '0'
            Log To Console    ${title} is 0, can't be clicked — skipping
            CONTINUE
        END

        Log To Console    Clicking card: ${title}
        Scroll Element Into View    ${click_card}
        Sleep    1s
        Click Element    ${click_card}
        RETURN    CLICKED
    END
    Log To Console    All KPI cards have 0 data — nothing to click
    RETURN    SKIPPED

Verify Reports Page URL Contains Filters
    [Arguments]    ${expected_date_column}    ${expected_date_preset}
    Wait Until Location Contains    /invoice-check/reports    40s
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
    Wait For Dashboard Cards To Load
    # Wait for cards to visually update after filter change
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    30s
    Wait Until Element Is Visible    ${DASHBOARD_HEADING}      30s
    Sleep    5s

    # Check all cards for zero before clicking
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}
    ${all_zero}=    Set Variable    ${TRUE}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1
        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-2xl')]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}' or '${title}' == '${EXCLUDED_CARD_3}'
            CONTINUE
        END

        ${value}=        Get Text    ${value_locator}
        ${clean_value}=  Clean Number Text    ${value}

        IF    '${clean_value}' != '0'
            ${all_zero}=    Set Variable    ${FALSE}
        ELSE
            Log To Console    ${title} is 0, can't be clicked
        END
    END

    IF    ${all_zero}
        Log To Console    All KPI cards are 0 for ${expected_date_column} + ${expected_date_preset} — skipping
        RETURN
    END

    Click First Available KPI Card

    Verify Reports Page URL Contains Filters    ${expected_date_column}    ${expected_date_preset}

    Go Back
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
    Scroll To Top
    # Wait for cards to reload after going back
    Wait For Dashboard Cards To Load
    # Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    30s
    # Sleep    5s

Validate All Dashboard Filter Combinations
    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_MONTH_TILL_DATE}
    ...    date_column=invoice_date       date_preset=month_till_date

    # Validate Dashboard Filter Combination
    # ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_YEAR_TILL_DATE}
    # ...    date_column=invoice_date       date_preset=year_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=invoice_date       date_preset=last_month

    # Validate Dashboard Filter Combination
    # ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_FISCAL_YEAR}
    # ...    date_column=invoice_date       date_preset=fiscal_year

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_MONTH_TILL_DATE}
    ...    date_column=voucher_date       date_preset=month_till_date

    # Validate Dashboard Filter Combination
    # ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_YEAR_TILL_DATE}
    # ...    date_column=voucher_date       date_preset=year_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=voucher_date       date_preset=last_month

    # Validate Dashboard Filter Combination
    # ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_FISCAL_YEAR}
    # ...    date_column=voucher_date       date_preset=fiscal_year

# Get Random Start And End Date
#     ${today}=                   Get Current Date    result_format=%Y-%m-%d
#     ${today_dt}=                Convert Date        ${today}    datetime
#     ${current_day}=             Set Variable        ${today_dt.day}
#     ${current_month}=           Set Variable        ${today_dt.month}
#     ${current_year}=            Set Variable        ${today_dt.year}

#     # Random number of months to go back (1 to 10)
#     ${months_back}=             Evaluate    random.randint(1, 10)    modules=random

#     # Calculate start month and year
#     ${total_start_month}=       Evaluate    ${current_month} - ${months_back}
#     ${start_year}=              Evaluate    ${current_year} if ${total_start_month} > 0 else ${current_year} - 1
#     ${start_month}=             Evaluate    ${total_start_month} if ${total_start_month} > 0 else ${total_start_month} + 12

#     # Get max days in start month to pick valid random day
#     ${max_start_day}=           Evaluate    calendar.monthrange(${start_year}, ${start_month})[1]    modules=calendar
#     ${start_day}=               Evaluate    random.randint(1, ${max_start_day})    modules=random

#     # Random number of months after start month for end month (1 to months_back)
#     ${months_forward}=          Evaluate    random.randint(1, ${months_back})    modules=random
#     ${total_end_month}=         Evaluate    ${start_month} + ${months_forward}
#     ${end_year}=                Evaluate    ${start_year} if ${total_end_month} <= 12 else ${start_year} + 1
#     ${end_month}=               Evaluate    ${total_end_month} if ${total_end_month} <= 12 else ${total_end_month} - 12

#     # Make sure end month does not exceed current month
#     ${end_month}=               Evaluate    ${current_month} if (${end_year} == ${current_year} and ${end_month} > ${current_month}) else ${end_month}
#     ${end_year}=                Evaluate    ${current_year} if ${end_year} > ${current_year} else ${end_year}

#     # Get max days in end month — if end is current month, cap at today
#     ${max_end_day}=             Evaluate    calendar.monthrange(${end_year}, ${end_month})[1]    modules=calendar
#     ${max_end_day}=             Evaluate    ${current_day} if (${end_year} == ${current_year} and ${end_month} == ${current_month}) else ${max_end_day}
#     ${end_day}=                 Evaluate    random.randint(1, ${max_end_day})    modules=random

#     # Format for URL verification (YYYY-MM-DD)
#     ${start_month_padded}=      Evaluate    str(${start_month}).zfill(2)
#     ${end_month_padded}=        Evaluate    str(${end_month}).zfill(2)
#     ${start_day_padded}=        Evaluate    str(${start_day}).zfill(2)
#     ${end_day_padded}=          Evaluate    str(${end_day}).zfill(2)

#     ${from_date}=               Set Variable    ${start_year}-${start_month_padded}-${start_day_padded}
#     ${to_date}=                 Set Variable    ${end_year}-${end_month_padded}-${end_day_padded}

#     # Format for data-day attribute (M/D/YYYY) — no zero padding
#     ${start_data_day}=          Set Variable    ${start_month}/${start_day}/${start_year}
#     ${end_data_day}=            Set Variable    ${end_month}/${end_day}/${end_year}

#     # Calculate how many times to click left arrow from current month to reach start month
#     ${clicks_needed}=           Evaluate    (${current_year} - ${start_year}) * 12 + (${current_month} - ${start_month})

#     # Calculate how many times to click right arrow from start month to reach end month
#     ${right_clicks_needed}=     Evaluate    (${end_year} - ${start_year}) * 12 + (${end_month} - ${start_month})

#     Log To Console              \nMonths back: ${months_back} | Start: ${from_date} | End: ${to_date}
#     Log To Console              Left arrow clicks: ${clicks_needed} | Right arrow clicks: ${right_clicks_needed}

#     RETURN    ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

# Select Custom Date Range
#     [Arguments]    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

#     ${prev_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Previous Month']
#     ${next_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Next Month']

#     Execute JavaScript    window.scrollTo(0, 0)
#     Sleep    2s

#     Wait Until Page Contains Element    ${prev_arrow}    30s
#     Sleep    1s

#     # Navigate back to start month
#     FOR    ${i}    IN RANGE    ${clicks_needed}
#         Wait Until Page Contains Element    ${prev_arrow}    10s
#         ${arrow}=    Get WebElement    ${prev_arrow}
#         Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
#         Sleep    0.5s
#     END

#     # Pick start date
#     ${start_locator}=    Set Variable    xpath=//button[@data-day='${start_data_day}']
#     Wait Until Page Contains Element    ${start_locator}    10s
#     ${start_btn}=    Get WebElement    ${start_locator}
#     Execute JavaScript    arguments[0].click()    ARGUMENTS    ${start_btn}
#     Sleep    1s

#     # Navigate right to end month
#     FOR    ${i}    IN RANGE    ${right_clicks_needed}
#         Wait Until Page Contains Element    ${next_arrow}    10s
#         ${arrow}=    Get WebElement    ${next_arrow}
#         Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
#         Sleep    0.5s
#     END

#     # Pick end date
#     ${end_locator}=    Set Variable    xpath=//button[@data-day='${end_data_day}']
#     Wait Until Page Contains Element    ${end_locator}    10s
#     ${end_btn}=    Get WebElement    ${end_locator}
#     Execute JavaScript    arguments[0].click()    ARGUMENTS    ${end_btn}
#     Sleep    1s

#     # Click apply
#     Wait Until Page Contains Element    ${CUSTOM_RANGE_APPLY_BUTTON}    10s
#     ${apply_btn}=    Get WebElement    ${CUSTOM_RANGE_APPLY_BUTTON}
#     Execute JavaScript    arguments[0].click()    ARGUMENTS    ${apply_btn}
#     Sleep    3s

# Validate Custom Range Filter Combination
#     [Arguments]    ${date_column_option}    ${expected_date_column}

#     Log To Console    \n--- Testing Custom Range: ${expected_date_column} ---

#     ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}=
#     ...    Get Random Start And End Date

#     Select Date Column Filter       ${date_column_option}

#     # Always reset: switch to Month Till Date first, then back to Custom Range
#     Select Date Range Filter    ${DATE_RANGE_MONTH_TILL_DATE}
#     Sleep    1s
#     Select Date Range Filter    ${DATE_RANGE_CUSTOM_RANGE}
#     Sleep    2s

#     Select Custom Date Range        ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

#     # Wait for dashboard cards to fully load visually
#     Wait For Dashboard Cards To Load

#     # Check if no data available for selected range
#     ${no_data}=    Run Keyword And Return Status
#     ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}
#     IF    ${no_data}
#         Log To Console    \nNo data available for selected range: ${from_date} to ${to_date} — skipping
#         RETURN
#     END

#     Click First Available KPI Card

#     Wait Until Location Contains    /invoice-check/reports    40s
#     Wait Until Element Is Visible   ${REPORTS_HEADING}        20s
#     Sleep    2s

#     ${current_url}=    Get Location
#     Log To Console    \nCurrent URL: ${current_url}

#     Should Contain    ${current_url}    ${expected_date_column}
#     Should Contain    ${current_url}    date_preset=custom_range
#     Should Contain    ${current_url}    from=${from_date}
#     Should Contain    ${current_url}    to=${to_date}

#     Log To Console    URL verified for custom range: ${from_date} to ${to_date}

#     Go Back
#     Wait Until Location Contains    /invoice-check/dashboard    20s
#     Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
#     Scroll To Top
#     Wait For Dashboard Cards To Load

# Validate All Custom Range Filter Combinations
#     Validate Custom Range Filter Combination
#     ...    ${DATE_COLUMN_INVOICE_DATE}
#     ...    date_column=invoice_date

#     Validate Custom Range Filter Combination
#     ...    ${DATE_COLUMN_VOUCHER_DATE}
#     ...    date_column=voucher_date

# Select Month From Custom Month Picker
#     [Arguments]    ${combobox_locator}    ${month_name}
#     Wait Until Element Is Visible    ${combobox_locator}    10s
#     Click Element                    ${combobox_locator}
#     Sleep    1s
#     Execute JavaScript    Array.from(document.querySelectorAll('*')).find(el => el.textContent.trim() === '${month_name}' && el.children.length === 0).click()
#     Sleep    1s

# Select Year From Custom Month Picker
#     [Arguments]    ${combobox_locator}    ${year}
#     Wait Until Element Is Visible    ${combobox_locator}    10s
#     Click Element                    ${combobox_locator}
#     Sleep    1s
#     Execute JavaScript    Array.from(document.querySelectorAll('*')).find(el => el.textContent.trim() === '${year}' && el.children.length === 0).click()
#     Sleep    1s

# Select Month From Custom Month Picker
#     [Arguments]    ${combobox_locator}    ${month_name}
#     Wait Until Element Is Visible    ${combobox_locator}    10s
#     ${btn}=    Get WebElement    ${combobox_locator}
#     Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${btn}
#     Sleep    0.5s
#     Execute JavaScript    arguments[0].click()    ARGUMENTS    ${btn}
#     Sleep    1s
#     Execute JavaScript    Array.from(document.querySelectorAll('*')).find(el => el.textContent.trim() === '${month_name}' && el.children.length === 0).click()
#     Sleep    1s

Select Month From Custom Month Picker
    [Arguments]    ${combobox_locator}    ${month_name}
    Wait Until Element Is Visible    ${combobox_locator}    10s
    ${btn}=    Get WebElement    ${combobox_locator}
    Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${btn}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${btn}
    Sleep    1s
    ${option}=    Get WebElement    xpath=//div[@data-state='open']//div[@role='option'][normalize-space()='${month_name}']
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${option}
    Sleep    1s

# Select Year From Custom Month Picker
#     [Arguments]    ${combobox_locator}    ${year}
#     Wait Until Element Is Visible    ${combobox_locator}    10s
#     ${btn}=    Get WebElement    ${combobox_locator}
#     Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${btn}
#     Sleep    0.5s
#     Execute JavaScript    arguments[0].click()    ARGUMENTS    ${btn}
#     Sleep    1s
#     Execute JavaScript    Array.from(document.querySelectorAll('*')).find(el => el.textContent.trim() === '${year}' && el.children.length === 0).click()
#     Sleep    1s

Select Year From Custom Month Picker
    [Arguments]    ${combobox_locator}    ${year}
    Wait Until Element Is Visible    ${combobox_locator}    10s
    ${btn}=    Get WebElement    ${combobox_locator}
    Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${btn}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${btn}
    Sleep    1s
    ${option}=    Get WebElement    xpath=//div[@data-state='open']//div[@role='option'][normalize-space()='${year}']
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${option}
    Sleep    1s

Get Random Custom Month Range
    ${today}=              Get Current Date    result_format=%Y-%m-%d
    ${today_dt}=           Convert Date        ${today}    datetime
    ${current_month}=      Set Variable        ${today_dt.month}
    ${current_year}=       Set Variable        ${today_dt.year}
    ${max_year}=           Evaluate    ${current_year} + 1

    # Pick random from year between 2016 and current year
    ${from_year}=          Evaluate    random.randint(2016, ${current_year})    modules=random

    # Pick random from month
    ${max_from_month}=     Evaluate    ${current_month} if ${from_year} == ${current_year} else 12
    ${from_month_num}=     Evaluate    random.randint(1, ${max_from_month})    modules=random

    # Pick random to year between from year and max year
    ${to_year}=            Evaluate    random.randint(${from_year}, ${max_year})    modules=random

    # Pick random to month
    ${min_to_month}=       Evaluate    ${from_month_num} if ${to_year} == ${from_year} else 1
    ${max_to_month}=       Evaluate    ${current_month} if ${to_year} == ${current_year} else 12
    ${to_month_num}=       Evaluate    random.randint(${min_to_month}, ${max_to_month})    modules=random

    # Convert month numbers to names
    ${months}=             Create List    January    February    March    April    May    June    July    August    September    October    November    December
    ${from_month_name}=    Get From List    ${months}    ${from_month_num - 1}
    ${to_month_name}=      Get From List    ${months}    ${to_month_num - 1}

    # Format from/to for URL verification
    ${from_month_padded}=  Evaluate    str(${from_month_num}).zfill(2)
    ${to_month_padded}=    Evaluate    str(${to_month_num}).zfill(2)

    # Get last day of to month
    ${last_day}=           Evaluate    calendar.monthrange(${to_year}, ${to_month_num})[1]    modules=calendar

    ${from_date}=          Set Variable    ${from_year}-${from_month_padded}-01
    ${to_date}=            Set Variable    ${to_year}-${to_month_padded}-${last_day}

    Log To Console         \nFrom: ${from_month_name} ${from_year} | To: ${to_month_name} ${to_year}
    Log To Console         URL from: ${from_date} | URL to: ${to_date}

    RETURN    ${from_month_name}    ${from_year}    ${to_month_name}    ${to_year}    ${from_date}    ${to_date}

Select Custom Month Range And Apply
    [Arguments]    ${from_month_name}    ${from_year}    ${to_month_name}    ${to_year}

    Wait Until Element Is Visible    ${CUSTOM_MONTH_FROM_MONTH}    15s
    Sleep    1s

    # Select From Month
    Select Month From Custom Month Picker    ${CUSTOM_MONTH_FROM_MONTH}    ${from_month_name}

    # Select From Year
    Select Year From Custom Month Picker    ${CUSTOM_MONTH_FROM_YEAR}    ${from_year}

    # Select To Month
    Select Month From Custom Month Picker    ${CUSTOM_MONTH_TO_MONTH}    ${to_month_name}

    # Select To Year
    Select Year From Custom Month Picker    ${CUSTOM_MONTH_TO_YEAR}    ${to_year}

    # Close any open dropdown by pressing Escape
    # Press Keys    None    ESCAPE
    # Sleep    1s

    # Scroll to Apply button and click via JS
    Wait Until Element Is Visible    ${CUSTOM_MONTH_APPLY_BUTTON}    10s
    ${apply}=    Get WebElement    ${CUSTOM_MONTH_APPLY_BUTTON}
    Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${apply}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${apply}
    Sleep    3s
    
# Select Custom Month Range And Apply
#     [Arguments]    ${from_month_name}    ${from_year}    ${to_month_name}    ${to_year}

#     # Open Custom Month Range picker trigger
#     Wait Until Element Is Visible    ${CUSTOM_RANGE_DATE_TRIGGER}    10s
#     Click Element                    ${CUSTOM_RANGE_DATE_TRIGGER}
#     Sleep    2s

#     # Select From Month
#     Select Month From Custom Month Picker    ${CUSTOM_MONTH_FROM_MONTH}    ${from_month_name}

#     # Select From Year
#     Select Year From Custom Month Picker    ${CUSTOM_MONTH_FROM_YEAR}    ${from_year}

#     # Select To Month
#     Select Month From Custom Month Picker    ${CUSTOM_MONTH_TO_MONTH}    ${to_month_name}

#     # Select To Year
#     Select Year From Custom Month Picker    ${CUSTOM_MONTH_TO_YEAR}    ${to_year}

#     # Click Apply
#     Wait Until Element Is Visible    ${CUSTOM_MONTH_APPLY_BUTTON}    10s
#     Click Element                    ${CUSTOM_MONTH_APPLY_BUTTON}
#     Sleep    3s

Validate Dashboard Custom Month Range Filter Combination
    [Arguments]    ${date_column_option}    ${expected_date_column}

    Log To Console    \n--- Testing Custom Month Range: ${expected_date_column} ---

    ${from_month_name}    ${from_year}    ${to_month_name}    ${to_year}    ${from_date}    ${to_date}=
    ...    Get Random Custom Month Range

    Select Date Column Filter    ${date_column_option}
    Select Date Range Filter     ${DATE_RANGE_CUSTOM_MONTH_RANGE}
    Sleep    2s

    Select Custom Month Range And Apply
    ...    ${from_month_name}    ${from_year}    ${to_month_name}    ${to_year}

    Wait Until Location Contains    date_preset=custom_month_range    20s
    Wait Until Location Contains    ${expected_date_column}           20s
    ${dashboard_url}=    Get Location
    ${from_date}=    Fetch From Right    ${dashboard_url}    from=
    ${from_date}=    Fetch From Left     ${from_date}         &
    ${to_date}=      Fetch From Right    ${dashboard_url}    to=
    Log To Console    \nFilter applied — URL confirmed | from=${from_date} | to=${to_date}

    Wait For Dashboard Cards To Load

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo data available for selected range: ${from_date} to ${to_date} — skipping
        RETURN
    END

    ${clicked}=    Click First Available KPI Card
    IF    '${clicked}' == 'SKIPPED'
        Log To Console    All cards are 0 — nothing to verify on reports page
        RETURN
    END

    Wait Until Location Contains    /invoice-check/reports    40s
    Wait Until Element Is Visible   ${REPORTS_HEADING}        20s
    Sleep    2s

    ${current_url}=    Get Location
    Log To Console    \nCurrent URL: ${current_url}

    Should Contain    ${current_url}    ${expected_date_column}
    Should Contain    ${current_url}    date_preset=custom_month_range
    Should Contain    ${current_url}    from=${from_date}
    Should Contain    ${current_url}    to=${to_date}

    Log To Console    URL verified for custom month range: ${from_date} to ${to_date}

    Go Back
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible   ${DASHBOARD_HEADING}        20s
    Scroll To Top
    Wait For Dashboard Cards To Load

Reset Dashboard Filters
    ${reset_btn_locator}=    Set Variable    xpath=(//button[@aria-label='Reset filters'])[1]
    Wait Until Element Is Visible    ${reset_btn_locator}    20s
    ${reset_btn}=    Get WebElement    ${reset_btn_locator}
    Scroll Element Into View         ${reset_btn}
    Sleep    0.5s
    Click Element    ${reset_btn}
    Sleep    2s
    Wait For Dashboard Cards To Load

Validate All Dashboard Custom Month Range Combinations
    Validate Dashboard Custom Month Range Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}
    ...    date_column=invoice_date

    Reset Dashboard Filters

    Validate Dashboard Custom Month Range Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}
    ...    date_column=voucher_date

Wait For Dashboard Cards To Load
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    60s
    # Wait until at least one card value is not empty — confirms visual load
    Wait Until Element Is Visible    xpath=(//main//div[contains(@class,'h-full') and contains(@class,'bg-card')])[1]//div[contains(@class,'text-2xl')]    30s
    Sleep    3s
