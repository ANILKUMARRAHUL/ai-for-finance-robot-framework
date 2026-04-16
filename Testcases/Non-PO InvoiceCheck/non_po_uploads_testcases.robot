*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/non_po_uploads_keywords.robot
Resource    ../../Keywords/non_po_dashboard_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify NonPO Invoice Upload With Incomplete And Complete Flow
    [Tags]    uploads    invoice    payment_request
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Go To NonPO Uploads Page
    Verify NonPO Uploads Page
    Verify NonPO Invoice Upload Negative Then Positive