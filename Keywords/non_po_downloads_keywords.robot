*** Settings ***
Library      SeleniumLibrary
Library      String
Library      Collections
Variables    ../Variables/non_po_downloads_variables.py
Variables    ../Variables/non_po_invoice_check_variables.py

*** Keywords ***
Wait For Page To Stabilize
    Sleep    2s

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Go To NonPO Downloads Page
    Wait Until Element Is Visible    ${NONPO_SIDENAV_DOWNLOADS}    20s
    Click Element                    ${NONPO_SIDENAV_DOWNLOADS}

Verify NonPO Downloads Page
    Wait Until Location Contains    downloads    20s
    Wait Until Element Is Visible   ${NONPO_DOWNLOADS_HEADING}        20s
    Wait For Page To Stabilize

Select Random Option From NonPO Dropdown
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

Select Random NonPO Supplier
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${NONPO_SUPPLIER_DROPDOWN}    20s
    Click Element                       ${NONPO_SUPPLIER_DROPDOWN}
    Sleep    2s

    Wait Until Page Contains Element    ${NONPO_SUPPLIER_OPTIONS}    10s
    ${options}=         Get WebElements    ${NONPO_SUPPLIER_OPTIONS}
    ${options_count}=   Get Length         ${options}
    Log To Console      \nTotal suppliers found: ${options_count}

    ${random_index}=    Evaluate    random.randint(0, ${options_count} - 1)    modules=random
    ${selected}=        Get Text    ${options}[${random_index}]
    Log To Console      Selected supplier: ${selected}

    Click Element    ${options}[${random_index}]
    Sleep    1s

    Press Keys    None    ESCAPE
    Sleep    1s

Select Random NonPO Date Column
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${NONPO_DOWNLOADS_DATE_COLUMN_DROPDOWN}    20s
    Click Element                       ${NONPO_DOWNLOADS_DATE_COLUMN_DROPDOWN}
    Sleep    2s

    ${date_column_options}=    Create List
    ...    ${NONPO_DOWNLOADS_DATE_COLUMN_UPLOAD}
    ...    ${NONPO_DOWNLOADS_DATE_COLUMN_INVOICE}

    ${random_index}=    Evaluate    random.randint(0, 1)    modules=random
    ${selected}=        Get Text     ${date_column_options}[${random_index}]
    Click Element                    ${date_column_options}[${random_index}]
    Sleep    2s
    Log To Console    Selected date column: ${selected}

Select Random NonPO Date Range
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${NONPO_DOWNLOADS_DATE_RANGE_DROPDOWN}    20s
    Click Element                       ${NONPO_DOWNLOADS_DATE_RANGE_DROPDOWN}
    Sleep    2s

    ${date_range_options}=    Create List
    ...    ${NONPO_DOWNLOADS_DATE_RANGE_MONTH}
    # ...    ${NONPO_DOWNLOADS_DATE_RANGE_YEAR}
    ...    ${NONPO_DOWNLOADS_DATE_RANGE_LAST_MONTH}
    # ...    ${NONPO_DOWNLOADS_DATE_RANGE_FISCAL}

    ${random_index}=    Evaluate    random.randint(0, 1)    modules=random
    ${selected}=        Get Text     ${date_range_options}[${random_index}]
    Click Element                    ${date_range_options}[${random_index}]
    Sleep    2s
    Log To Console    Selected date range: ${selected}    

Generate NonPO Report And Verify Toast
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${NONPO_GENERATE_REPORT_BUTTON}    20s
    Click Element                       ${NONPO_GENERATE_REPORT_BUTTON}
    Sleep    1s

    # Verify toast appears within 3 seconds
    Wait Until Page Contains Element    ${NONPO_REPORT_GENERATION_TOAST}    3s
    ${toast_text}=    Get Text          ${NONPO_REPORT_GENERATION_TOAST}
    Log To Console    \nToast message: ${toast_text}
    Should Contain    ${toast_text}     Report created and processing started
    Log To Console    Toast verified successfully

Validate Generate NonPO Report With Random Filters
    Log To Console    \n--- Selecting Random Filters ---

    Log To Console    \nSelecting Report Type...
    ${report_type}=    Select Random Option From NonPO Dropdown    ${NONPO_REPORT_TYPE_DROPDOWN}
    Log To Console     Report Type: ${report_type}

    # Log To Console    \nSelecting Supplier...
    # Select Random NonPO Supplier

    Log To Console    \nSelecting Date Column...
    Select Random NonPO Date Column

    Log To Console    \nSelecting Date Range...
    Select Random NonPO Date Range

    Log To Console    \nGenerating Report...
    Generate NonPO Report And Verify Toast

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}

Select NonPO Downloads Rows Per Page
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${NONPO_DOWNLOADS_ROWS_PER_PAGE_DROPDOWN}    20s
    Click Element                       ${NONPO_DOWNLOADS_ROWS_PER_PAGE_DROPDOWN}
    Sleep    2s
    Wait Until Page Contains Element    ${option_locator}    10s
    Click Element                       ${option_locator}
    Sleep    3s

Validate NonPO Downloads Rows Per Page Option
    [Arguments]    ${option_locator}    ${expected_count}
    Log To Console    \n--- Checking Downloads Rows Per Page: ${expected_count} ---

    Select NonPO Downloads Rows Per Page    ${option_locator}

    Wait Until Page Contains Element    ${NONPO_DOWNLOADS_TABLE_ROWS}      30s
    Wait Until Page Contains Element    ${NONPO_DOWNLOADS_SHOWING_TEXT}    30s
    Wait For Page To Stabilize

    ${rows}=          Get WebElements    ${NONPO_DOWNLOADS_TABLE_ROWS}
    ${actual_count}=  Get Length         ${rows}
    Log To Console    Rendered rows: ${actual_count}

    ${showing_text}=    Get Text    ${NONPO_DOWNLOADS_SHOWING_TEXT}
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

Validate All NonPO Downloads Rows Per Page Options
    # Check if no data available before starting
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_DOWNLOADS_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo reports found in Download History — skipping Rows Per Page validation
        RETURN
    END

    Validate NonPO Downloads Rows Per Page Option    ${NONPO_DOWNLOADS_ROWS_PER_PAGE_5}     5
    Validate NonPO Downloads Rows Per Page Option    ${NONPO_DOWNLOADS_ROWS_PER_PAGE_10}    10
    Validate NonPO Downloads Rows Per Page Option    ${NONPO_DOWNLOADS_ROWS_PER_PAGE_25}    25
    Validate NonPO Downloads Rows Per Page Option    ${NONPO_DOWNLOADS_ROWS_PER_PAGE_50}    50
