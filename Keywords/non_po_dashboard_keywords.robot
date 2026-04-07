*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    DateTime
Variables    ../Variables/non_po_invoice_check_variables.py
Variables    ../Variables/home_variables.py

*** Keywords ***
Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Wait For Page To Stabilize
    Sleep    5s

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}

Slow Scroll To Bottom
    ${height}=    Execute JavaScript    return document.body.scrollHeight
    FOR    ${i}    IN RANGE    0    ${height}    400
        Execute JavaScript    window.scrollTo(0, ${i})
        Sleep    0.4s
    END
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s

Go To NonPO Dashboard Page
    Wait Until Element Is Visible    ${OPEN_NON_INVOICE_CHECK_BUTTON}    20s
    Click Element                    ${OPEN_NON_INVOICE_CHECK_BUTTON}

Verify NonPO Dashboard Page
    Wait Until Location Contains    /non-po/dashboard    20s
    Wait Until Element Is Visible   ${NONPO_DASHBOARD_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Go To NonPO Reports Page
    Wait Until Element Is Visible    ${NONPO_SIDENAV_REPORTS}    20s
    Click Element                    ${NONPO_SIDENAV_REPORTS}

Verify NonPO Reports Page
    Wait Until Location Contains    /non-po/reports    20s
    Wait Until Element Is Visible   ${NONPO_REPORTS_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Wait For NonPO Dashboard Cards To Load
    Wait Until Element Is Visible    ${NONPO_DASHBOARD_KPI_CARDS}    60s
    Wait Until Element Is Visible    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[1]//div[contains(@class,'text-4xl')]    30s
    Sleep    3s

Select NonPO Date Column Filter
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Element Is Visible    ${NONPO_DATE_COLUMN_DROPDOWN}    20s
    Click Element                    ${NONPO_DATE_COLUMN_DROPDOWN}
    Sleep    2s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Select NonPO Date Range Filter
    [Arguments]    ${option_locator}
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s
    Wait Until Element Is Visible    ${NONPO_DATE_RANGE_DROPDOWN}    20s
    Click Element                    ${NONPO_DATE_RANGE_DROPDOWN}
    Sleep    2s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Click First Available NonPO KPI Card
    Wait For NonPO Dashboard Cards To Load
    ${cards}=    Get WebElements    ${NONPO_DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-4xl')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

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
        RETURN
    END
    Log To Console    All NonPO KPI cards have 0 data — nothing to click

Validate NonPO Dashboard KPI Cards With Reports Count
    Wait For NonPO Dashboard Cards To Load
    ${cards}=    Get WebElements    ${NONPO_DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-4xl')]
        ${click_card}=       Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

        Log To Console    \nChecking card: ${title}

        ${value}=           Get Text    ${value_locator}
        ${clean_value}=     Clean Number Text    ${value}

        IF    '${clean_value}' == '0'
            Log To Console    ${title} is 0, can't be clicked — skipping
            CONTINUE
        END

        # Hover to get exact tooltip value
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

        Wait Until Location Contains    /non-po/reports    20s
        Wait Until Element Is Visible   ${NONPO_REPORTS_HEADING}    20s
        Wait Until Element Is Visible   ${NONPO_REPORTS_BOTTOM_TOTAL}    20s

        Slow Scroll To Bottom

        ${reports_total}=    Get Text    ${NONPO_REPORTS_BOTTOM_TOTAL}
        ${reports_count}=    Clean Number Text    ${reports_total}

        Log To Console    Reports total: ${reports_count}

        Should Be Equal    ${dashboard_count}    ${reports_count}

        Go Back
        Wait Until Location Contains    /non-po/dashboard    20s
        Wait Until Element Is Visible   ${NONPO_DASHBOARD_HEADING}    20s
        Scroll To Top
        Wait For NonPO Dashboard Cards To Load
    END

Verify NonPO Reports Page URL Contains Filters
    [Arguments]    ${expected_date_column}    ${expected_date_preset}
    Wait Until Location Contains    /non-po/reports    20s
    Wait Until Element Is Visible   ${NONPO_REPORTS_HEADING}    20s
    Sleep    2s
    ${current_url}=    Get Location
    Log To Console    \nCurrent URL: ${current_url}
    Should Contain    ${current_url}    ${expected_date_column}
    Should Contain    ${current_url}    ${expected_date_preset}
    Log To Console    URL contains expected filters: ${expected_date_column} | ${expected_date_preset}

Validate NonPO Dashboard Filter Combination
    [Arguments]    ${date_column_option}    ${date_range_option}    ${expected_date_column}    ${expected_date_preset}
    Log To Console    \n--- Testing: ${expected_date_column} + ${expected_date_preset} ---

    Select NonPO Date Column Filter    ${date_column_option}
    Select NonPO Date Range Filter     ${date_range_option}
    Wait For NonPO Dashboard Cards To Load

    # Check all cards for zero before clicking
    ${cards}=    Get WebElements    ${NONPO_DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}
    ${all_zero}=    Set Variable    ${TRUE}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1
        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'bg-card')])[${position}]//div[contains(@class,'text-4xl')]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}

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

    Click First Available NonPO KPI Card

    Verify NonPO Reports Page URL Contains Filters    ${expected_date_column}    ${expected_date_preset}

    Go Back
    Wait Until Location Contains    /non-po/dashboard    20s
    Wait Until Element Is Visible   ${NONPO_DASHBOARD_HEADING}    20s
    Scroll To Top
    Wait For NonPO Dashboard Cards To Load

Validate All NonPO Dashboard Filter Combinations
    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_UPLOAD}    ${NONPO_DATE_RANGE_MONTH}
    ...    date_column=created_on         date_preset=month_till_date

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_UPLOAD}    ${NONPO_DATE_RANGE_YEAR}
    ...    date_column=created_on         date_preset=year_till_date

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_UPLOAD}    ${NONPO_DATE_RANGE_LAST_MONTH}
    ...    date_column=created_on         date_preset=last_month

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_UPLOAD}    ${NONPO_DATE_RANGE_FISCAL}
    ...    date_column=created_on         date_preset=fiscal_year

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_INVOICE}    ${NONPO_DATE_RANGE_MONTH}
    ...    date_column=invoice_date        date_preset=month_till_date

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_INVOICE}    ${NONPO_DATE_RANGE_YEAR}
    ...    date_column=invoice_date        date_preset=year_till_date

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_INVOICE}    ${NONPO_DATE_RANGE_LAST_MONTH}
    ...    date_column=invoice_date        date_preset=last_month

    Validate NonPO Dashboard Filter Combination
    ...    ${NONPO_DATE_COLUMN_INVOICE}    ${NONPO_DATE_RANGE_FISCAL}
    ...    date_column=invoice_date        date_preset=fiscal_year

# =========================
# RECONCILIATION VIEW BY
# =========================

Scroll To NonPO Reconciliation Table
    Wait Until Element Is Visible    ${NONPO_RECON_TABLE_HEADING}    20s
    Scroll Element Into View         ${NONPO_RECON_TABLE_HEADING}
    Sleep    2s

Open NonPO View By Dropdown
    Wait Until Element Is Visible    ${NONPO_VIEW_BY_DROPDOWN}    20s
    Scroll Element Into View         ${NONPO_VIEW_BY_DROPDOWN}
    Sleep    1s
    Click Element                    ${NONPO_VIEW_BY_DROPDOWN}
    Sleep    2s

Select NonPO View By Option
    [Arguments]    ${option_locator}
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    2s

Get NonPO Reconciliation Column Header
    Wait Until Element Is Visible    ${NONPO_RECON_COLUMN_HEADER}    20s
    ${header}=    Get Text    ${NONPO_RECON_COLUMN_HEADER}
    Log To Console    \nColumn Header: ${header}
    RETURN    ${header}

Validate NonPO View By Filter Change
    [Arguments]    ${filter_name}    ${option_locator}    ${expected_keyword}
    Log To Console    \n--- Checking Filter: ${filter_name} ---

    Open NonPO View By Dropdown
    Select NonPO View By Option    ${option_locator}

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    No data available for filter: ${filter_name} — skipping header check
        RETURN
    END

    ${header}=    Get NonPO Reconciliation Column Header
    Should Contain    ${header}    ${expected_keyword}

Validate NonPO Reconciliation View By Filters
    Scroll To NonPO Reconciliation Table

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nReconciliation table has no data — skipping all View By filter checks
        RETURN
    END

    Validate NonPO View By Filter Change    Month      ${NONPO_VIEW_BY_MONTH_OPTION}      (
    Validate NonPO View By Filter Change    Quarter    ${NONPO_VIEW_BY_QUARTER_OPTION}    Q
    Validate NonPO View By Filter Change    Year       ${NONPO_VIEW_BY_YEAR_OPTION}       20

# =========================
# CUSTOM RANGE
# =========================

Get NonPO Random Start And End Date
    ${today}=                   Get Current Date    result_format=%Y-%m-%d
    ${today_dt}=                Convert Date        ${today}    datetime
    ${current_day}=             Set Variable        ${today_dt.day}
    ${current_month}=           Set Variable        ${today_dt.month}
    ${current_year}=            Set Variable        ${today_dt.year}

    ${months_back}=             Evaluate    random.randint(1, 10)    modules=random

    ${total_start_month}=       Evaluate    ${current_month} - ${months_back}
    ${start_year}=              Evaluate    ${current_year} if ${total_start_month} > 0 else ${current_year} - 1
    ${start_month}=             Evaluate    ${total_start_month} if ${total_start_month} > 0 else ${total_start_month} + 12

    ${max_start_day}=           Evaluate    calendar.monthrange(${start_year}, ${start_month})[1]    modules=calendar
    ${start_day}=               Evaluate    random.randint(1, ${max_start_day})    modules=random

    ${months_forward}=          Evaluate    random.randint(1, ${months_back})    modules=random
    ${total_end_month}=         Evaluate    ${start_month} + ${months_forward}
    ${end_year}=                Evaluate    ${start_year} if ${total_end_month} <= 12 else ${start_year} + 1
    ${end_month}=               Evaluate    ${total_end_month} if ${total_end_month} <= 12 else ${total_end_month} - 12

    ${end_month}=               Evaluate    ${current_month} if (${end_year} == ${current_year} and ${end_month} > ${current_month}) else ${end_month}
    ${end_year}=                Evaluate    ${current_year} if ${end_year} > ${current_year} else ${end_year}

    ${max_end_day}=             Evaluate    calendar.monthrange(${end_year}, ${end_month})[1]    modules=calendar
    ${max_end_day}=             Evaluate    ${current_day} if (${end_year} == ${current_year} and ${end_month} == ${current_month}) else ${max_end_day}
    ${end_day}=                 Evaluate    random.randint(1, ${max_end_day})    modules=random

    ${start_month_padded}=      Evaluate    str(${start_month}).zfill(2)
    ${end_month_padded}=        Evaluate    str(${end_month}).zfill(2)
    ${start_day_padded}=        Evaluate    str(${start_day}).zfill(2)
    ${end_day_padded}=          Evaluate    str(${end_day}).zfill(2)

    ${from_date}=               Set Variable    ${start_year}-${start_month_padded}-${start_day_padded}
    ${to_date}=                 Set Variable    ${end_year}-${end_month_padded}-${end_day_padded}

    ${start_data_day}=          Set Variable    ${start_month}/${start_day}/${start_year}
    ${end_data_day}=            Set Variable    ${end_month}/${end_day}/${end_year}

    ${clicks_needed}=           Evaluate    (${current_year} - ${start_year}) * 12 + (${current_month} - ${start_month})
    ${right_clicks_needed}=     Evaluate    (${end_year} - ${start_year}) * 12 + (${end_month} - ${start_month})

    Log To Console              \nMonths back: ${months_back} | Start: ${from_date} | End: ${to_date}
    Log To Console              Left arrow clicks: ${clicks_needed} | Right arrow clicks: ${right_clicks_needed}

    RETURN    ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

Select NonPO Custom Date Range
    [Arguments]    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

    ${prev_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Previous Month']
    ${next_arrow}=    Set Variable    xpath=//button[@aria-label='Go to the Next Month']

    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s

    Wait Until Page Contains Element    ${prev_arrow}    30s
    Sleep    1s

    FOR    ${i}    IN RANGE    ${clicks_needed}
        Wait Until Page Contains Element    ${prev_arrow}    10s
        ${arrow}=    Get WebElement    ${prev_arrow}
        Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
        Sleep    0.5s
    END

    ${start_locator}=    Set Variable    xpath=//button[@data-day='${start_data_day}']
    Wait Until Page Contains Element    ${start_locator}    10s
    ${start_btn}=    Get WebElement    ${start_locator}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${start_btn}
    Sleep    1s

    FOR    ${i}    IN RANGE    ${right_clicks_needed}
        Wait Until Page Contains Element    ${next_arrow}    10s
        ${arrow}=    Get WebElement    ${next_arrow}
        Execute JavaScript    arguments[0].click()    ARGUMENTS    ${arrow}
        Sleep    0.5s
    END

    ${end_locator}=    Set Variable    xpath=//button[@data-day='${end_data_day}']
    Wait Until Page Contains Element    ${end_locator}    10s
    ${end_btn}=    Get WebElement    ${end_locator}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${end_btn}
    Sleep    1s

    Wait Until Page Contains Element    ${NONPO_CUSTOM_RANGE_APPLY}    10s
    ${apply_btn}=    Get WebElement    ${NONPO_CUSTOM_RANGE_APPLY}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${apply_btn}
    Sleep    3s

Validate NonPO Custom Range Filter Combination
    [Arguments]    ${date_column_option}    ${expected_date_column}

    Log To Console    \n--- Testing Custom Range: ${expected_date_column} ---

    ${from_date}    ${to_date}    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}=
    ...    Get NonPO Random Start And End Date

    Select NonPO Date Column Filter    ${date_column_option}

    # Always reset: switch to Month Till Date first, then back to Custom Range
    Select NonPO Date Range Filter    ${NONPO_DATE_RANGE_MONTH}
    Sleep    1s
    Select NonPO Date Range Filter    ${NONPO_DATE_RANGE_CUSTOM}
    Sleep    2s

    Select NonPO Custom Date Range    ${start_data_day}    ${end_data_day}    ${clicks_needed}    ${right_clicks_needed}

    Wait For NonPO Dashboard Cards To Load

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo data available for selected range: ${from_date} to ${to_date} — skipping
        RETURN
    END

    Click First Available NonPO KPI Card

    Wait Until Location Contains    /non-po/reports    20s
    Wait Until Element Is Visible   ${NONPO_REPORTS_HEADING}    20s
    Sleep    2s

    ${current_url}=    Get Location
    Log To Console    \nCurrent URL: ${current_url}

    Should Contain    ${current_url}    ${expected_date_column}
    Should Contain    ${current_url}    date_preset=custom_range
    Should Contain    ${current_url}    from=${from_date}
    Should Contain    ${current_url}    to=${to_date}

    Log To Console    URL verified for custom range: ${from_date} to ${to_date}

    Go Back
    Wait Until Location Contains    /non-po/dashboard    20s
    Wait Until Element Is Visible   ${NONPO_DASHBOARD_HEADING}    20s
    Scroll To Top
    Wait For NonPO Dashboard Cards To Load

Validate All NonPO Custom Range Filter Combinations
    Validate NonPO Custom Range Filter Combination
    ...    ${NONPO_DATE_COLUMN_UPLOAD}
    ...    date_column=created_on

    Validate NonPO Custom Range Filter Combination
    ...    ${NONPO_DATE_COLUMN_INVOICE}
    ...    date_column=invoice_date