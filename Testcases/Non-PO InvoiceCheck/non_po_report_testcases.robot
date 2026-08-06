*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/non_po_dashboard_keywords.robot
Resource    ../../Keywords/non_po_report_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify NonPO Reports Page Tabs Columns And Pagination
    [Documentation]
    ...    Navigates to the Non-PO Reports page and:
    ...      1. Clicks the 'Payment Requests' tab and verifies the URL changes.
    ...      2. Validates the Columns toggle (ON/OFF) on the Payment Requests tab.
    ...      3. Validates pagination (rows-per-page + Next/Prev) on the Payment Requests tab.
    ...      4. Clicks the 'Invoices' tab and verifies the URL changes.
    ...      5. Validates the Columns toggle (ON/OFF) on the Invoices tab.
    ...      6. Validates pagination (rows-per-page + Next/Prev) on the Invoices tab.
    [Tags]    reports    tabs    columns    pagination
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Validate NonPO Reports Tabs Columns And Pagination

Verify NonPO Reports Ready For Review And Finance Review Flow
    [Documentation]
    ...    On the Non-PO Reports page:
    ...      1. Goes to the Payment Requests tab and selects the 'Ready for Review' filter.
    ...      2. Clicks a random PR number from the filtered table.
    ...      3. Clicks the Invoices tab on the PR detail page (if present).
    ...      4. Clicks the eye icon on the first invoice row to open invoice detail.
    ...      5. Clicks the 'Start Finance Review' button.
    [Tags]    reports    invoices    finance_review    ready_for_review
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Validate Ready For Review And Finance Review Flow
