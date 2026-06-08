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
    Sleep   3s
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s

        ${title_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//div[contains(@class,'uppercase')]

        ${value_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//span[contains(@class,'font-bold')]

        ${click_card}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]

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

        ${title_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//div[contains(@class,'uppercase')]

        ${value_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//span[contains(@class,'font-bold')]

        ${click_card}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]

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
        ${title_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//div[contains(@class,'uppercase')]

        ${value_locator}=    Set Variable
        ...    (${DASHBOARD_KPI_CARDS})[${position}]//span[contains(@class,'font-bold')]

        
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'rounded-xl') and contains(@class,'border')])[${position}]//span[contains(@class,'font-bold')]

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


    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=invoice_date       date_preset=last_month

    # Validate Dashboard Filter Combination
    # ...    ${DATE_COLUMN_INVOICE_DATE}    ${DATE_RANGE_FISCAL_YEAR}
    # ...    date_column=invoice_date       date_preset=fiscal_year

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_MONTH_TILL_DATE}
    ...    date_column=voucher_date       date_preset=month_till_date

    Validate Dashboard Filter Combination
    ...    ${DATE_COLUMN_VOUCHER_DATE}    ${DATE_RANGE_LAST_MONTH}
    ...    date_column=voucher_date       date_preset=last_month

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
    Wait Until Element Is Visible    xpath=//section[contains(@class,'bg-card')]    60s
    Sleep    3s


Open State Code Dropdown
    Wait Until Element Is Visible    ${STATE_CODE_DROPDOWN}    timeout=10s
    Scroll Element Into View         ${STATE_CODE_DROPDOWN}
    Sleep    1s
    Click Element                    ${STATE_CODE_DROPDOWN}
    Sleep    2s

Get All State Options Count
    Wait Until Element Is Visible    xpath=//*[@cmdk-item][@role='option']    10s
    ${options}=    Get WebElements    xpath=//*[@cmdk-item][@role='option']
    ${count}=      Get Length         ${options}
    Log To Console    Total states found: ${count}
    RETURN    ${count}

Select State By Index
    [Arguments]    ${index}
    ${locator}=    Set Variable    xpath=(//*[@cmdk-item][@role='option'])[${index}]
    Wait Until Element Is Visible    ${locator}    10s
    ${option}=    Get WebElement    ${locator}
    Execute JavaScript    arguments[0].scrollIntoView({block: 'center'})    ARGUMENTS    ${option}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${option}
    Sleep    1s

Get State Label By Index
    [Arguments]    ${index}
    ${locator}=    Set Variable    xpath=(//*[@cmdk-item][@role='option'])[${index}]
    ${label}=    Get Text    ${locator}
    RETURN    ${label}

Close State Code Dropdown
    Press Keys    None    ESCAPE
    Sleep    1s

Select Each State And Verify Data Loads
    ${state_labels}=    Get All State Labels
    ${total}=    Get Length    ${state_labels}

    FOR    ${index}    IN RANGE    ${total}

        ${state_label}=    Get From List    ${state_labels}    ${index}

        Log To Console
        ...    \nSelecting state [${index + 1}/${total}] : ${state_label}

        # Open dropdown
        Open State Code Dropdown

        # Select state
        Select State By Label    ${state_label}

        # Apply filter
        Click State Filter Apply Button

        # Wait for dashboard reload
        Wait For Dashboard Reload After Filter

        # Validate data / no data
        ${no_data}=    Run Keyword And Return Status
        ...    Element Should Be Visible    ${DASHBOARD_NO_DATA_MESSAGE}

        IF    ${no_data}
            Log To Console
            ...    No data available for: ${state_label}
        ELSE
            Log To Console
            ...    Data loaded successfully for: ${state_label}
        END

        # Remove applied filter
        Remove Applied State Filter

        Log To Console
        ...    Removed filter for: ${state_label}

    END

    Log To Console
    ...    \nAll state validations completed successfully

Click State Filter Apply Button
    Wait Until Element Is Visible    ${STATE_FILTER_APPLY_BUTTON}    10s

    ${apply_btn}=    Get WebElement    ${STATE_FILTER_APPLY_BUTTON}

    Execute JavaScript
    ...    arguments[0].scrollIntoView({block:'center'})
    ...    ARGUMENTS    ${apply_btn}

    Sleep    0.5s

    Execute JavaScript
    ...    arguments[0].click()
    ...    ARGUMENTS    ${apply_btn}

    Sleep    2s

Wait For Dashboard Reload After Filter
    Wait Until Element Is Visible    ${DASHBOARD_CARDS_SECTION}    60s

    # Small stabilization wait for API/UI rendering
    Sleep    3s

Remove Applied State Filter
    Wait Until Element Is Visible    ${REMOVE_SELECTED_STATE_BUTTON}    10s
    Scroll Element Into View    ${REMOVE_SELECTED_STATE_BUTTON}
    Sleep    1s
    Click Element    ${REMOVE_SELECTED_STATE_BUTTON}
    Sleep    2s
    Wait For Dashboard Reload After Filter

Select State By Label
    [Arguments]    ${state_label}
    ${locator}=    Set Variable
    ...    xpath=//*[@cmdk-item][@role='option'][normalize-space()='${state_label}']
    Wait Until Element Is Visible    ${locator}    10s
    ${option}=    Get WebElement    ${locator}
    Execute JavaScript
    ...    arguments[0].scrollIntoView({block:'center'})
    ...    ARGUMENTS    ${option}
    Sleep    0.5s
    Execute JavaScript
    ...    arguments[0].click()
    ...    ARGUMENTS    ${option}
    Sleep    1s

Get All State Labels
    Open State Code Dropdown

    Wait Until Element Is Visible    ${STATE_OPTIONS}    10s

    ${elements}=    Get WebElements    ${STATE_OPTIONS}

    ${state_labels}=    Create List

    FOR    ${element}    IN    @{elements}
        ${label}=    Get Text    ${element}
        ${label}=    Strip String    ${label}

        IF    '${label}' != ''
            Append To List    ${state_labels}    ${label}
        END
    END

    Log To Console    \nStates Found: ${state_labels}

    Close State Code Dropdown

    RETURN    ${state_labels}

