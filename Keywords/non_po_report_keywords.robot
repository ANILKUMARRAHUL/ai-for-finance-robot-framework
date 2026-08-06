*** Settings ***
Library      SeleniumLibrary
Library      String
Library      Collections
Variables    ../Variables/non_po_invoice_check_variables.py
Variables    ../Variables/non_po_report_variables.py

*** Keywords ***
# ═══════════════════════════════════════════════════════
# UTILITY
# ═══════════════════════════════════════════════════════
Wait For Page To Stabilize
    Sleep    3s

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [,\\s]    ${EMPTY}
    RETURN    ${clean}

# ═══════════════════════════════════════════════════════
# NAVIGATION
# ═══════════════════════════════════════════════════════
Go To NonPO Reports Page
    Wait Until Element Is Visible    ${NONPO_SIDENAV_REPORTS}    20s
    Click Element                    ${NONPO_SIDENAV_REPORTS}
    Wait Until Location Contains     /non-po/reports    20s
    Wait Until Element Is Visible    ${NONPO_REPORTS_HEADING}    20s
    Wait For Page To Stabilize

# ═══════════════════════════════════════════════════════
# TAB NAVIGATION
# ═══════════════════════════════════════════════════════
Click Payment Requests Tab
    Wait Until Element Is Visible    ${NONPO_REPORTS_TAB_PAYMENT_REQUESTS}    15s
    Click Element                    ${NONPO_REPORTS_TAB_PAYMENT_REQUESTS}
    Sleep    2s
    Wait Until Location Contains     tab=pr    20s
    Log To Console    Clicked Payment Requests tab -- URL updated

Click Invoices Tab
    Wait Until Element Is Visible    ${NONPO_REPORTS_TAB_INVOICES}    15s
    Click Element                    ${NONPO_REPORTS_TAB_INVOICES}
    Sleep    2s
    Wait Until Location Contains     tab=invoices    20s
    Log To Console    Clicked Invoices tab -- URL updated

# ═══════════════════════════════════════════════════════
# COLUMNS TOGGLE
# ═══════════════════════════════════════════════════════
Open Columns Manager
    Scroll To Top
    Wait Until Element Is Visible    ${NONPO_REPORTS_COLUMNS_BTN}    15s
    ${col_btn}=    Get WebElement    ${NONPO_REPORTS_COLUMNS_BTN}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${col_btn}
    Sleep    2s
    # Wait for the popover content with column toggle checkboxes to appear
    ${found}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    xpath=//div[@data-slot='popover-content']//button[@role='checkbox']    10s
    IF    not ${found}
        # Fallback: popover may use data-state=open without data-slot
        Wait Until Element Is Visible
        ...    xpath=//button[@role='checkbox']    10s
    END
    Log To Console    Columns manager opened


Get All Column Toggles
    # Try primary locator (popover-content slot) first
    ${items}=    Run Keyword And Return Status
    ...    Page Should Contain Element
    ...    xpath=//div[@data-slot='popover-content']//button[@role='checkbox']
    IF    ${items}
        ${toggles}=    Get WebElements    xpath=//div[@data-slot='popover-content']//button[@role='checkbox']
    ELSE
        ${toggles}=    Get WebElements    xpath=//button[@role='checkbox']
    END
    RETURN    ${toggles}

Toggle Column By Index
    [Arguments]    ${index}
    ${items}=    Get All Column Toggles
    ${item}=     Get From List    ${items}    ${index}
    ${label}=    Execute JavaScript    return arguments[0].textContent.trim()    ARGUMENTS    ${item}
    ${before}=   Execute JavaScript    return arguments[0].getAttribute('aria-checked')    ARGUMENTS    ${item}
    Log To Console    Toggling column "${label}" (currently aria-checked=${before})
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${item}
    Sleep    1.5s
    ${after}=    Execute JavaScript    return arguments[0].getAttribute('aria-checked')    ARGUMENTS    ${item}
    Log To Console    Column "${label}" toggled: ${before} to ${after}
    RETURN    ${label}    ${before}    ${after}

Close Columns Manager By Pressing Escape
    Press Keys    None    ESCAPE
    Sleep    1s

Validate Columns Toggle On And Off
    [Documentation]    Opens the Columns manager, toggles the first column OFF then back ON and verifies state changes.
    Open Columns Manager
    ${items}=    Get All Column Toggles
    ${total}=    Get Length    ${items}
    Log To Console    \\nTotal toggleable columns: ${total}

    ${label}    ${before}    ${after}=    Toggle Column By Index    0
    Run Keyword If    '${before}' == 'true'
    ...    Should Be Equal    ${after}    false
    ...    ELSE    Log To Console    Column was already OFF -- toggling ON instead

    Sleep    1s

    ${label}    ${before2}    ${after2}=    Toggle Column By Index    0
    Run Keyword If    '${before2}' == 'false'
    ...    Should Be Equal    ${after2}    true
    ...    ELSE    Log To Console    Column toggled back as expected

    Log To Console    Columns toggle ON/OFF verified for column: ${label}

    ${reset_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_REPORTS_COLUMNS_RESET}
    IF    ${reset_visible}
        Click Element    ${NONPO_REPORTS_COLUMNS_RESET}
        Sleep    1s
        Log To Console    Columns reset to default
    END

    Close Columns Manager By Pressing Escape

# ═══════════════════════════════════════════════════════
# PAGINATION - GENERIC
# ═══════════════════════════════════════════════════════
Validate Rows Per Page For Current Tab
    [Arguments]    ${rows_dropdown}    ${rows_locator_10}    ${showing_text_locator}    ${table_rows_locator}    ${tab_name}
    [Documentation]    Validates rows-per-page for 10 rows on the current tab.

    Log To Console    \\n--- Checking rows-per-page (10) on ${tab_name} tab ---

    ${no_data}=    Run Keyword And Return Status
    ...    Page Should Not Contain Element    ${table_rows_locator}
    IF    ${no_data}
        Log To Console    No table rows found on ${tab_name} -- skipping pagination check
        RETURN
    END

    # Rows-per-page dropdown is at the BOTTOM of the page — scroll to it first
    Wait Until Page Contains Element    ${rows_dropdown}    20s
    ${dd_elem}=    Get WebElement    ${rows_dropdown}
    Execute JavaScript    arguments[0].scrollIntoView({block:'center'})    ARGUMENTS    ${dd_elem}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${dd_elem}
    Sleep    2s

    Wait Until Page Contains Element    ${rows_locator_10}    10s
    ${opt_elem}=    Get WebElement    ${rows_locator_10}
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${opt_elem}
    Sleep    1s
    Wait For Page To Stabilize

    Wait Until Page Contains Element    ${table_rows_locator}    30s
    Wait Until Page Contains Element    ${showing_text_locator}  30s

    ${rows}=          Get WebElements    ${table_rows_locator}
    ${actual_count}=  Get Length         ${rows}
    ${showing_text}=  Get Text           ${showing_text_locator}
    Log To Console    Rows: ${actual_count} | Pagination: ${showing_text}

    Should Contain    ${showing_text}    1 to ${actual_count}
    Log To Console    Rows-per-page pagination verified on ${tab_name}

Validate Next And Previous Page Navigation
    [Arguments]    ${next_btn}    ${prev_btn}    ${showing_text_locator}    ${table_rows_locator}    ${tab_name}
    [Documentation]    Clicks Next then Previous and verifies pagination text changes.

    Log To Console    \\n--- Checking Next/Prev pagination on ${tab_name} tab ---

    ${no_data}=    Run Keyword And Return Status
    ...    Page Should Not Contain Element    ${table_rows_locator}
    IF    ${no_data}
        Log To Console    No table rows on ${tab_name} -- skipping next/prev check
        RETURN
    END

    ${has_next}=    Run Keyword And Return Status
    ...    Element Should Be Enabled    ${next_btn}
    IF    not ${has_next}
        Log To Console    Only one page of results -- Next is disabled. Skipping.
        RETURN
    END

    ${text_before}=    Get Text    ${showing_text_locator}
    Log To Console    Before Next: ${text_before}

    Click Element    ${next_btn}
    Sleep    2s
    Wait Until Page Contains Element    ${table_rows_locator}    20s
    Wait For Page To Stabilize

    ${text_after}=    Get Text    ${showing_text_locator}
    Log To Console    After Next: ${text_after}
    Should Not Be Equal    ${text_before}    ${text_after}
    Log To Console    Next page navigation verified

    ${has_prev}=    Run Keyword And Return Status
    ...    Element Should Be Enabled    ${prev_btn}
    IF    ${has_prev}
        Click Element    ${prev_btn}
        Sleep    2s
        Wait Until Page Contains Element    ${table_rows_locator}    20s
        ${text_back}=    Get Text    ${showing_text_locator}
        Log To Console    After Prev: ${text_back}
        Should Be Equal    ${text_before}    ${text_back}
        Log To Console    Previous page navigation verified
    END

# ═══════════════════════════════════════════════════════
# PAGINATION - PAYMENT REQUESTS TAB
# ═══════════════════════════════════════════════════════
Validate Payment Requests Tab Pagination
    Validate Rows Per Page For Current Tab
    ...    ${NONPO_PR_ROWS_PER_PAGE_DROPDOWN}
    ...    ${NONPO_PR_ROWS_PER_PAGE_10}
    ...    ${NONPO_PR_SHOWING_TEXT}
    ...    ${NONPO_PR_TABLE_ROWS}
    ...    Payment Requests

    Validate Next And Previous Page Navigation
    ...    ${NONPO_PR_NEXT_PAGE_BTN}
    ...    ${NONPO_PR_PREV_PAGE_BTN}
    ...    ${NONPO_PR_SHOWING_TEXT}
    ...    ${NONPO_PR_TABLE_ROWS}
    ...    Payment Requests

# ═══════════════════════════════════════════════════════
# PAGINATION - INVOICES TAB
# ═══════════════════════════════════════════════════════
Validate Invoices Tab Pagination
    Validate Rows Per Page For Current Tab
    ...    ${NONPO_INV_ROWS_PER_PAGE_DROPDOWN}
    ...    ${NONPO_INV_ROWS_PER_PAGE_10}
    ...    ${NONPO_INV_SHOWING_TEXT}
    ...    ${NONPO_INV_TABLE_ROWS}
    ...    Invoices

    Validate Next And Previous Page Navigation
    ...    ${NONPO_INV_NEXT_PAGE_BTN}
    ...    ${NONPO_INV_PREV_PAGE_BTN}
    ...    ${NONPO_INV_SHOWING_TEXT}
    ...    ${NONPO_INV_TABLE_ROWS}
    ...    Invoices

# ═══════════════════════════════════════════════════════
# READY FOR REVIEW FILTER
# ═══════════════════════════════════════════════════════
Select Ready For Review Status Filter
    [Documentation]    Applies the 'Ready for Review' filter on the Payment Requests tab.
    Scroll To Top
    Wait For Page To Stabilize

    # On Payment Requests tab there is a visible "Ready for Review" quick-filter button
    ${ready_btn_locator}=    Set Variable
    ...    xpath=//button[normalize-space()='Ready for Review' or (contains(.,'Ready') and contains(.,'Review'))]

    ${btn_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${ready_btn_locator}
    IF    ${btn_visible}
        Click Element    ${ready_btn_locator}
        Sleep    2s
        Log To Console    Clicked 'Ready for Review' quick-filter button
    ELSE
        Log To Console    Quick-filter button not found -- trying Status dropdown
        Wait Until Element Is Visible    ${NONPO_INV_STATUS_DROPDOWN}    15s
        Click Element                    ${NONPO_INV_STATUS_DROPDOWN}
        Sleep    2s
        Wait Until Element Is Visible    ${NONPO_INV_STATUS_READY_FOR_REVIEW}    10s
        Click Element                    ${NONPO_INV_STATUS_READY_FOR_REVIEW}
        Sleep    1s
        ${apply_visible}=    Run Keyword And Return Status
        ...    Element Should Be Visible    xpath=//button[normalize-space()='Apply']
        IF    ${apply_visible}
            Click Element    xpath=//button[normalize-space()='Apply']
            Sleep    2s
        END
    END
    Wait For Page To Stabilize
    Log To Console    'Ready for Review' filter applied

# ═══════════════════════════════════════════════════════
# CLICK RANDOM PR NUMBER
# ═══════════════════════════════════════════════════════
Click Random PR Number
    [Documentation]
    ...    Finds all clickable PR number elements in the table and clicks a random one.
    ...    Uses sequential locator fallback — avoids XPath union operator which is
    ...    unreliable with SeleniumLibrary's Get WebElements.
    ...    Skips gracefully if the table is empty after filter.

    # ── 1. Verify the table has at least one row ──────────────────────────
    ${has_rows}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    xpath=//table//tbody//tr    10s
    IF    not ${has_rows}
        Log    PR table is empty after 'Ready for Review' filter -- skipping    WARN
        Skip    No payment requests found with Ready for Review status
    END

    # ── 2. Try locators in priority order (no union) ──────────────────────
    # Pattern A: cursor-pointer span in td[2] (same as PO invoice-check reports)
    ${elements}=    Run Keyword And Return Status
    ...    Page Should Contain Element
    ...    xpath=//table//tbody//tr//td[2]//span[contains(@class,'cursor-pointer')]
    IF    ${elements}
        ${pr_links}=    Get WebElements    xpath=//table//tbody//tr//td[2]//span[contains(@class,'cursor-pointer')]
    ELSE
        # Pattern B: any span with cursor class in td[2]
        ${elements2}=    Run Keyword And Return Status
        ...    Page Should Contain Element
        ...    xpath=//table//tbody//tr//td[2]//span[contains(@class,'cursor')]
        IF    ${elements2}
            ${pr_links}=    Get WebElements    xpath=//table//tbody//tr//td[2]//span[contains(@class,'cursor')]
        ELSE
            # Pattern C: anchor tags starting with PR text
            ${elements3}=    Run Keyword And Return Status
            ...    Page Should Contain Element
            ...    xpath=//table//tbody//tr//td//a[starts-with(normalize-space(),'PR')]
            IF    ${elements3}
                ${pr_links}=    Get WebElements    xpath=//table//tbody//tr//td//a[starts-with(normalize-space(),'PR')]
            ELSE
                # Pattern D: fall back to the raw td[2] cell (clickable row)
                ${pr_links}=    Get WebElements    xpath=//table//tbody//tr//td[2]
            END
        END
    END

    ${count}=    Get Length    ${pr_links}
    Log To Console    \\nTotal PR links found: ${count}
    IF    ${count} == 0
        Log    No clickable PR elements found -- skipping    WARN
        Skip    No PR links found in the table
    END

    # ── 3. Click a random element ─────────────────────────────────────────
    ${random_index}=    Evaluate    random.randint(1, ${count} - 1)    modules=random
    ${elem}=    Get From List    ${pr_links}    ${random_index}
    ${chosen}=  Execute JavaScript    return arguments[0].textContent.trim()    ARGUMENTS    ${elem}
    Log To Console    Clicking PR: ${chosen} (index ${random_index})

    Execute JavaScript    arguments[0].scrollIntoView({block:'center'})    ARGUMENTS    ${elem}
    Sleep    0.5s
    Execute JavaScript    arguments[0].click()    ARGUMENTS    ${elem}

    Wait For Page To Stabilize
    Log To Console    Navigated into PR: ${chosen}
    RETURN    ${chosen}


# ═══════════════════════════════════════════════════════
# CLICK EYE ICON IN INVOICES TAB OF PR DETAIL PAGE
# ═══════════════════════════════════════════════════════
Click Eye Icon In Invoices Tab
    [Documentation]    Inside the PR detail page, clicks the first eye icon in the invoice table.
    ${eye_locator}=    Set Variable
    ...    xpath=(//span[@title='View Report Details'])[1]

    ${found}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${eye_locator}    10s

    IF    not ${found}
        # Fallback: first icon-button with SVG eye or first button in invoice row
        ${fallback}=    Set Variable
        ...    xpath=//table//tbody//tr[1]//button[contains(@class,'icon') or @data-slot='icon-button'][1]
        ${found2}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    ${fallback}    10s
        IF    ${found2}
            Scroll Element Into View    ${fallback}
            Sleep    0.3s
            Click Element    ${fallback}
        ELSE
            # Last resort: any first button in first row
            Wait Until Element Is Visible    xpath=//table//tbody//tr[1]//button[1]    15s
            Click Element                    xpath=//table//tbody//tr[1]//button[1]
        END
    ELSE
        Scroll Element Into View    ${eye_locator}
        Sleep    0.3s
        Click Element    ${eye_locator}
    END
    Wait For Page To Stabilize
    Log To Console    Eye icon clicked -- navigated to invoice detail

# ═══════════════════════════════════════════════════════
# START FINANCE REVIEW
# ═══════════════════════════════════════════════════════
Click Start Finance Review Button
    [Documentation]    Clicks the 'Start Finance Review' button on the invoice detail page.
    Wait Until Element Is Visible    ${NONPO_INV_START_FINANCE_REVIEW_BTN}    20s
    Scroll Element Into View         ${NONPO_INV_START_FINANCE_REVIEW_BTN}
    Sleep    0.5s
    Click Element                    ${NONPO_INV_START_FINANCE_REVIEW_BTN}
    Sleep    2s
    Log To Console    'Start Finance Review' button clicked

# ═══════════════════════════════════════════════════════
# HIGH-LEVEL ORCHESTRATORS
# ═══════════════════════════════════════════════════════
Validate NonPO Reports Tabs Columns And Pagination
    [Documentation]
    ...    1. Navigate to Reports page
    ...    2. Click Payment Requests tab -- verify URL + columns toggle + pagination
    ...    3. Click Invoices tab         -- verify URL + columns toggle + pagination

    Go To NonPO Reports Page

    # -- Payment Requests Tab --
    Click Payment Requests Tab
    Log To Console    \\n=== PAYMENT REQUESTS TAB ===
    Validate Columns Toggle On And Off
    Validate Payment Requests Tab Pagination

    # -- Invoices Tab --
    Click Invoices Tab
    Log To Console    \\n=== INVOICES TAB ===
    Validate Columns Toggle On And Off
    Validate Invoices Tab Pagination

Validate Ready For Review And Finance Review Flow
    [Documentation]
    ...    1. Go to Reports page
    ...    2. On Payment Requests tab -- select 'Ready for Review' status filter
    ...    3. Click a random PR number
    ...    4. In the PR detail page -- click Invoices tab if needed
    ...    5. Click the eye icon on the first invoice row
    ...    6. Click 'Start Finance Review' button

    Go To NonPO Reports Page
    Click Payment Requests Tab
    Select Ready For Review Status Filter

    ${pr_number}=    Click Random PR Number

    # The PR detail page may have its own Invoices tab -- switch to it
    ${inv_tab_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${NONPO_REPORTS_TAB_INVOICES}    5s
    IF    ${inv_tab_visible}
        Click Element    ${NONPO_REPORTS_TAB_INVOICES}
        Sleep    2s
    END

    ${no_data}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${NONPO_INV_NO_DATA_MESSAGE}
    IF    ${no_data}
        Log    No invoices found for PR ${pr_number} -- cannot proceed with eye icon click    WARN
        RETURN
    END

    Click Eye Icon In Invoices Tab
    Click Start Finance Review Button
