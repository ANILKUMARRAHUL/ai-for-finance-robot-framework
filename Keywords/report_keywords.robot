*** Settings ***
Library      SeleniumLibrary
Library      String
Library      Collections
Variables    ../Variables/report_variables.py

*** Keywords ***
Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Wait For Page To Stabilize
    Sleep    2s

Select Invoice Status Filter
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Element Is Visible    ${INVOICE_STATUS_DROPDOWN}    20s
    Click Element                    ${INVOICE_STATUS_DROPDOWN}
    Sleep    2s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Verify All Rows Status On Current Page
    [Arguments]    ${expected_status}
    ${status_cells}=    Get WebElements    ${REPORTS_STATUS_CELLS}
    ${row_count}=       Get Length         ${status_cells}
    Log To Console      \nChecking ${row_count} rows for status: ${expected_status}

    FOR    ${cell}    IN    @{status_cells}
        ${cell_text}=    Get Text    ${cell}
        Should Be Equal    ${cell_text}    ${expected_status}
    END

Verify Status Filter Across Pages
    [Arguments]    ${expected_status}    ${max_pages}=3

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${REPORTS_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo reports available for status: ${expected_status} — skipping row check
        RETURN
    END

    ${current_page}=    Set Variable    1

    WHILE    ${current_page} <= ${max_pages}
        Log To Console    \nVerifying page ${current_page} for status: ${expected_status}

        Wait Until Element Is Visible    ${REPORTS_STATUS_CELLS}      40s
        Wait Until Element Is Visible    ${REPORTS_PAGINATION_TEXT}    40s
        Wait For Page To Stabilize

        Verify All Rows Status On Current Page    ${expected_status}

        ${has_next}=    Run Keyword And Return Status
        ...    Element Should Be Enabled    ${REPORTS_NEXT_PAGE_BUTTON}

        Exit For Loop If    not ${has_next}
        Exit For Loop If    ${current_page} == ${max_pages}

        ${first_invoice}=    Get Text    xpath=//table//tbody//tr[1]//td[2]
        Click Element    ${REPORTS_NEXT_PAGE_BUTTON}

        Wait Until Element Is Visible                ${REPORTS_STATUS_CELLS}    40s
        Wait Until Page Does Not Contain Element
        ...    xpath=//table//tbody//tr[1]//td[2][normalize-space()='${first_invoice}']    40s
        Wait For Page To Stabilize

        ${current_page}=    Evaluate    ${current_page} + 1
    END

    Log To Console    \nFinished verifying ${current_page} pages for status: ${expected_status}

Validate Invoice Status Filter
    [Arguments]    ${option_locator}    ${expected_status}    ${expected_url_status}
    Log To Console    \n--- Testing Invoice Status Filter: ${expected_status} ---

    Select Invoice Status Filter    ${option_locator}
    Wait For Page To Stabilize

    ${current_url}=    Get Location
    Log To Console     \nCurrent URL: ${current_url}
    Should Contain     ${current_url}    status=${expected_url_status}

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${REPORTS_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo reports available for status: ${expected_status} — skipping table check
    ELSE
        Wait Until Element Is Visible    ${REPORTS_STATUS_CELLS}      40s
        Wait Until Element Is Visible    ${REPORTS_PAGINATION_TEXT}    40s
        Wait For Page To Stabilize
        Verify Status Filter Across Pages    ${expected_status}
    END

    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Element Is Visible    ${REPORTS_RESET_BUTTON}    20s
    Click Element                    ${REPORTS_RESET_BUTTON}
    Wait For Page To Stabilize

Validate All Invoice Status Filters
    Validate Invoice Status Filter
    ...    ${STATUS_MATCHED}
    ...    Matched
    ...    matched

    Validate Invoice Status Filter
    ...    ${STATUS_SUGGESTED_MATCH}
    ...    Suggested Match
    ...    suggested_match

    Validate Invoice Status Filter
    ...    ${STATUS_EXCEPTION}
    ...    Exception
    ...    exception

    Validate Invoice Status Filter
    ...    ${STATUS_FAILED}
    ...    Failed
    ...    failed

    Validate Invoice Status Filter
    ...    ${STATUS_TAX_MISMATCHED}
    ...    Tax Mismatched Record
    ...    tax_mismatched_record

    Validate Invoice Status Filter
    ...    ${STATUS_INVOICE_NOT_FOUND}
    ...    Invoice Not Found In RSCP
    ...    invoice_not_found_in_rscp

Select Rows Per Page
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Page Contains Element    ${ROWS_PER_PAGE_DROPDOWN}    20s
    Click Element                       ${ROWS_PER_PAGE_DROPDOWN}
    Sleep    2s
    Wait Until Page Contains Element    ${option_locator}    10s
    Click Element                       ${option_locator}
    Sleep    3s

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}

Validate Rows Per Page Option
    [Arguments]    ${option_locator}    ${expected_count}
    Log To Console    \n--- Checking Rows Per Page: ${expected_count} ---

    Select Rows Per Page    ${option_locator}

    # Wait for table to load
    Wait Until Page Contains Element    ${REPORTS_TABLE_ROWS}    30s
    Wait Until Page Contains Element    ${REPORTS_SHOWING_TEXT}    30s
    Wait For Page To Stabilize

    # Get actual row count rendered
    ${rows}=          Get WebElements    ${REPORTS_TABLE_ROWS}
    ${actual_count}=  Get Length         ${rows}
    Log To Console    Rendered rows: ${actual_count}

    # Get total records from pagination text
    ${showing_text}=    Get Text    ${REPORTS_SHOWING_TEXT}
    Log To Console      Pagination text: ${showing_text}

    # Extract total records count from "Showing 1 to X of Y reports"
    ${total_str}=       Fetch From Right    ${showing_text}    of${SPACE}
    ${total_str}=       Fetch From Left     ${total_str}       ${SPACE}
    ${total_count}=     Clean Number Text   ${total_str}
    ${total_int}=       Convert To Integer  ${total_count}
    ${expected_int}=    Convert To Integer  ${expected_count}

    Log To Console    Total records: ${total_int} | Expected per page: ${expected_int}

    # If total records less than expected — verify rows equal total
    IF    ${total_int} < ${expected_int}
        Log To Console    Total records less than expected — verifying rows equal total
        Should Be Equal As Integers    ${actual_count}    ${total_int}
    ELSE
        Should Be Equal As Integers    ${actual_count}    ${expected_int}
    END

    # Also verify pagination text contains correct range
    Should Contain    ${showing_text}    1 to ${actual_count}
    Log To Console    Rows per page ${expected_count} verified successfully

Validate All Rows Per Page Options
    # Check if no data available before starting
    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${REPORTS_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log To Console    \nNo reports available — skipping Rows Per Page validation
        RETURN
    END

    Validate Rows Per Page Option    ${ROWS_PER_PAGE_5}     5
    Validate Rows Per Page Option    ${ROWS_PER_PAGE_10}    10
    Validate Rows Per Page Option    ${ROWS_PER_PAGE_25}    25
    Validate Rows Per Page Option    ${ROWS_PER_PAGE_50}    50

# ─────────────────────────────────────────────
# EDIT INVOICE RECORD & UPDATE STATUS KEYWORDS
# ─────────────────────────────────────────────

Select Date Preset Filter
    [Arguments]    ${option_locator}
    Scroll To Top
    Wait For Page To Stabilize
    Wait Until Element Is Visible    ${DATE_PRESET_DROPDOWN}    20s
    Click Element                    ${DATE_PRESET_DROPDOWN}
    Sleep    2s
    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    3s

Apply Reports Filters For Edit Test
    Select Date Preset Filter       ${DATE_PRESET_LAST_MONTH}
    Select Invoice Status Filter    ${STATUS_MATCHED}
    Wait For Page To Stabilize

Open First Invoice Record If Available
    ${invoice_found}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${FIRST_INVOICE_LINK}    10s
    IF    not ${invoice_found}
        Log    No invoice records found for selected filters (Last Month / Voucher Date / Matched). Skipping test.    WARN
        Skip    No invoice records available for selected filters
    END
    Click Element    ${FIRST_INVOICE_LINK}
    Wait For Page To Stabilize

Verify Edit Button Is Present And Click
    Wait Until Element Is Visible    ${EDIT_BUTTON}    20s
    Page Should Contain Element      ${EDIT_BUTTON}
    Log To Console    Edit button is present on the invoice detail page
    Click Element    ${EDIT_BUTTON}
    Sleep    2s

Edit Invoice ITC Fields With Test Values
    # ── Number field: CGST Amount ──────────────────────────
    Scroll Element Into View         ${EDIT_CGST_INPUT}
    Wait Until Element Is Visible    ${EDIT_CGST_INPUT}    15s
    ${orig_cgst}=       Get Value    ${EDIT_CGST_INPUT}
    Log To Console      Original CGST Amount: ${orig_cgst}
    Click Element       ${EDIT_CGST_INPUT}
    ${new_cgst}=        Evaluate
    ...    str(round(float('${orig_cgst}') - 1, 2)) if '${orig_cgst}' not in ['', 'N/A'] else '1'
    Input Text          ${EDIT_CGST_INPUT}    ${new_cgst}
    Log To Console      Updated CGST Amount to: ${new_cgst}

    # ── Text field: Document Title ─────────────────────────
    Scroll Element Into View         ${EDIT_DOC_TITLE_INPUT}
    Wait Until Element Is Visible    ${EDIT_DOC_TITLE_INPUT}    15s
    ${orig_title}=      Get Value    ${EDIT_DOC_TITLE_INPUT}
    Log To Console      Original Document Title: ${orig_title}
    Click Element       ${EDIT_DOC_TITLE_INPUT}
    Input Text          ${EDIT_DOC_TITLE_INPUT}    Test Invoice Automation
    Log To Console      Updated Document Title to: Test Invoice Automation
    RETURN    ${orig_cgst}    ${orig_title}

Click Update Status And Confirm Without Changes In Popup
    Scroll To Top
    Wait Until Element Is Visible    ${UPDATE_STATUS_BTN}    20s
    Click Element                    ${UPDATE_STATUS_BTN}
    Wait Until Element Is Visible    ${UPDATE_STATUS_POPUP_BTN}    15s
    Log To Console    Update Status popup opened — not changing any values
    Click Element                    ${UPDATE_STATUS_POPUP_BTN}

Click Save Changes Button
    Scroll Element Into View         ${SAVE_CHANGES_BTN}
    Wait Until Element Is Visible    ${SAVE_CHANGES_BTN}    20s
    Click Element                    ${SAVE_CHANGES_BTN}
    Log To Console    Save Changes button clicked

Verify Success Toast Appears And Disappears
    Wait Until Element Is Visible      ${SUCCESS_TOAST}    15s
    Log To Console    Success toast visible: "Changes saved successfully"
    Wait Until Element Is Not Visible  ${SUCCESS_TOAST}    10s
    Log To Console    Success toast disappeared as expected

Restore Original Invoice ITC Field Values And Save
    [Arguments]    ${original_cgst}    ${original_doc_title}
    Verify Edit Button Is Present And Click
    Scroll Element Into View         ${EDIT_CGST_INPUT}
    Wait Until Element Is Visible    ${EDIT_CGST_INPUT}    15s
    Click Element    ${EDIT_CGST_INPUT}
    Input Text       ${EDIT_CGST_INPUT}    ${original_cgst}
    Log To Console   Restored CGST Amount to: ${original_cgst}
    Scroll Element Into View         ${EDIT_DOC_TITLE_INPUT}
    Wait Until Element Is Visible    ${EDIT_DOC_TITLE_INPUT}    15s
    Click Element    ${EDIT_DOC_TITLE_INPUT}
    Input Text       ${EDIT_DOC_TITLE_INPUT}    ${original_doc_title}
    Log To Console   Restored Document Title to: ${original_doc_title}
    Click Save Changes Button
    Verify Success Toast Appears And Disappears
    Log To Console   Original field values restored and saved successfully

Verify Hide And Show Summary Toggle
    Scroll To Top
    Wait Until Element Is Visible    ${HIDE_SUMMARY_BTN}    15s
    Wait Until Element Is Visible    ${SUMMARY_PANEL_INDICATOR}    5s
    Click Element                    ${HIDE_SUMMARY_BTN}
    Log To Console                   .Clicked Hide Summary button
    Wait Until Element Is Not Visible    ${SUMMARY_PANEL_INDICATOR}    10s
    Wait Until Element Is Visible    ${SHOW_SUMMARY_BTN}    10s
    Log To Console                   .Summary panel hidden successfully
    Click Element                    ${SHOW_SUMMARY_BTN}
    Log To Console                   .Clicked Show Summary button
    Wait Until Element Is Visible    ${SUMMARY_PANEL_INDICATOR}    10s
    Wait Until Element Is Visible    ${HIDE_SUMMARY_BTN}    10s
    Log To Console                   .Summary panel shown successfully