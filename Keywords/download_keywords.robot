*** Settings ***
Library      SeleniumLibrary
Library      String
Library      Collections
Variables    ../Variables/download_variables.py
Variables    ../Variables/invoice_check_variables.py

*** Keywords ***
Wait For Page To Stabilize
    Sleep    2s

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

# Go To Downloads Page
#     Wait Until Element Is Visible    ${SIDENAV_DOWNLOADS}    20s
#     Click Element                    ${SIDENAV_DOWNLOADS}

# Verify Downloads Page
#     Wait Until Location Contains    /invoice-check/downloads    20s
#     Wait Until Element Is Visible   ${DOWNLOADS_HEADING}        20s
#     Wait For Page To Stabilize

Select Random Option From Dropdown
    [Arguments]    ${dropdown_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${dropdown_locator}    20s
    Click Element                       ${dropdown_locator}
    Sleep    2s

    # Get all available options scoped to open dropdown only
    ${options}=         Get WebElements    xpath=//div[@data-state='open']//div[@role='option']
    ${options_count}=   Get Length         ${options}
    Log To Console      \nTotal options found: ${options_count}

    # Pick random index
    ${random_index}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random
    ${selected}=        Get Text    ${options}[${random_index}]
    Log To Console      Selected option: ${selected}

    Click Element    ${options}[${random_index}]
    Sleep    2s

    # Close any open dropdown
    Press Keys    None    ESCAPE
    Sleep    1s
    RETURN    ${selected}

Select Random Supplier
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${SUPPLIER_DROPDOWN}    20s
    Click Element                       ${SUPPLIER_DROPDOWN}
    Sleep    2s

    Wait Until Page Contains Element    ${VOUCHER_CODE_OPTIONS}    10s
    ${options}=         Get WebElements    ${VOUCHER_CODE_OPTIONS}
    ${options_count}=   Get Length         ${options}
    Log To Console      \nTotal suppliers found: ${options_count}

    ${random_index}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random
    ${selected}=        Get Text    ${options}[${random_index}]
    Log To Console      Selected supplier: ${selected}

    Click Element    ${options}[${random_index}]
    Sleep    1s

    Press Keys    None    ESCAPE
    Sleep    1s

Select Two Random Voucher Codes
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${VOUCHER_CODE_DROPDOWN}    20s
    Click Element                       ${VOUCHER_CODE_DROPDOWN}
    Sleep    2s

    # Wait for voucher code specific options
    Wait Until Page Contains Element    ${VOUCHER_CODE_OPTIONS}    10s
    ${options}=         Get WebElements    ${VOUCHER_CODE_OPTIONS}
    ${options_count}=   Get Length         ${options}
    Log To Console      \nTotal voucher codes found: ${options_count}

    # Pick 2 random unique indices
    ${index_1}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random
    ${index_2}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random

    WHILE    ${index_2} == ${index_1}
        ${index_2}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random
    END

    ${voucher_1}=    Get Text    ${options}[${index_1}]
    ${voucher_2}=    Get Text    ${options}[${index_2}]
    Log To Console    Selected voucher codes: ${voucher_1} | ${voucher_2}

    Click Element    ${options}[${index_1}]
    Sleep    1s

    # Re-fetch options after first click as DOM may refresh
    ${options}=    Get WebElements    ${VOUCHER_CODE_OPTIONS}
    Click Element    ${options}[${index_2}]
    Sleep    1s

    # Close dropdown
    Press Keys    None    ESCAPE
    Sleep    1s

Select Random Date Column
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${DOWNLOADS_DATE_COLUMN_DROPDOWN}    20s
    Click Element                       ${DOWNLOADS_DATE_COLUMN_DROPDOWN}
    Sleep    2s

    ${date_column_options}=    Create List
    ...    ${DOWNLOADS_DATE_COLUMN_INVOICE}
    ...    ${DOWNLOADS_DATE_COLUMN_VOUCHER}

    ${random_index}=    Evaluate    random.randint(0, 1)    modules=random
    ${selected}=        Get Text     ${date_column_options}[${random_index}]
    Click Element                    ${date_column_options}[${random_index}]
    Sleep    2s
    Log To Console    Selected date column: ${selected}

Select Random Date Range
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${DOWNLOADS_DATE_RANGE_DROPDOWN}    20s
    Click Element                       ${DOWNLOADS_DATE_RANGE_DROPDOWN}
    Sleep    2s

    ${date_range_options}=    Create List
    ...    ${DOWNLOADS_DATE_RANGE_MONTH}
    ...    ${DOWNLOADS_DATE_RANGE_YEAR}
    ...    ${DOWNLOADS_DATE_RANGE_LAST_MONTH}
    ...    ${DOWNLOADS_DATE_RANGE_FISCAL}

    ${random_index}=    Evaluate    random.randint(0, 3)    modules=random
    ${selected}=        Get Text     ${date_range_options}[${random_index}]
    Click Element                    ${date_range_options}[${random_index}]
    Sleep    2s
    Log To Console    Selected date range: ${selected}

Generate Report And Verify Toast
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${GENERATE_REPORT_BUTTON}    20s
    Click Element                       ${GENERATE_REPORT_BUTTON}
    Sleep    1s

    # Verify toast appears within 3 seconds
    Wait Until Page Contains Element    ${REPORT_GENERATION_TOAST}    3s
    ${toast_text}=    Get Text          ${REPORT_GENERATION_TOAST}
    Log To Console    \nToast message: ${toast_text}
    Should Contain    ${toast_text}     Report generation started
    Log To Console    Toast verified successfully

Validate Generate Report With Random Filters
    Log To Console    \n--- Selecting Random Filters ---

    Log To Console    \nSelecting Report Type...
    ${report_type}=    Select Random Option From Dropdown    ${REPORT_TYPE_DROPDOWN}
    Log To Console     Report Type: ${report_type}

    Log To Console    \nSelecting State Code...
    ${state_code}=    Select Random Option From Dropdown    ${STATE_CODE_DROPDOWN}
    Log To Console    State Code: ${state_code}

    Log To Console    \nSelecting Supplier...
    Select Random Supplier

    Log To Console    \nSelecting Voucher Codes...
    Select Two Random Voucher Codes

    Log To Console    \nSelecting Date Column...
    Select Random Date Column

    Log To Console    \nSelecting Date Range...
    Select Random Date Range

    Log To Console    \nGenerating Report...
    Generate Report And Verify Toast

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}

Select Downloads Rows Per Page
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${DOWNLOADS_ROWS_PER_PAGE_DROPDOWN}    20s
    Click Element                       ${DOWNLOADS_ROWS_PER_PAGE_DROPDOWN}
    Sleep    2s
    Wait Until Page Contains Element    ${option_locator}    10s
    Click Element                       ${option_locator}
    Sleep    3s

Validate Downloads Rows Per Page Option
    [Arguments]    ${option_locator}    ${expected_count}
    Log To Console    \n--- Checking Downloads Rows Per Page: ${expected_count} ---

    Select Downloads Rows Per Page    ${option_locator}

    Wait Until Page Contains Element    ${DOWNLOADS_TABLE_ROWS}      30s
    Wait Until Page Contains Element    ${DOWNLOADS_SHOWING_TEXT}    30s
    Wait For Page To Stabilize

    ${rows}=          Get WebElements    ${DOWNLOADS_TABLE_ROWS}
    ${actual_count}=  Get Length         ${rows}
    Log To Console    Rendered rows: ${actual_count}

    ${showing_text}=    Get Text    ${DOWNLOADS_SHOWING_TEXT}
    Log To Console      Pagination text: ${showing_text}

    ${total_str}=       Fetch From Right    ${showing_text}    of${SPACE}
    ${total_str}=       Fetch From Left     ${total_str}       ${SPACE}
    ${total_count}=     Clean Number Text   ${total_str}
    ${total_int}=       Convert To Integer  ${total_count}
    ${expected_int}=    Convert To Integer  ${expected_count}

    Log To Console    Total records: ${total_int} | Expected per page: ${expected_int}

    IF    ${total_int} < ${expected_int}
        Log To Console    Total records less than expected — verifying rows equal total
        Should Be Equal As Integers    ${actual_count}    ${total_int}
    ELSE
        Should Be Equal As Integers    ${actual_count}    ${expected_int}
    END

    Should Contain    ${showing_text}    1 to ${actual_count}
    Log To Console    Rows per page ${expected_count} verified successfully

Validate All Downloads Rows Per Page Options
    # Check if no data available before starting
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${DOWNLOADS_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo reports found in Download History — skipping Rows Per Page validation
        RETURN
    END

    Validate Downloads Rows Per Page Option    ${DOWNLOADS_ROWS_PER_PAGE_6}     6
    Validate Downloads Rows Per Page Option    ${DOWNLOADS_ROWS_PER_PAGE_10}    10
    Validate Downloads Rows Per Page Option    ${DOWNLOADS_ROWS_PER_PAGE_25}    25
    Validate Downloads Rows Per Page Option    ${DOWNLOADS_ROWS_PER_PAGE_50}    50