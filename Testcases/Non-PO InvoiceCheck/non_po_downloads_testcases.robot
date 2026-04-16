*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/non_po_downloads_keywords.robot
Resource    ../../Keywords/non_po_dashboard_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify Non-PO Invoice Check Downloads Page
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Go To NonPO Downloads Page
    Verify NonPO Downloads Page

Validate Generate Report With Random Filters On Non-PO Downloads Page
    [Tags]    downloads    filter    generate
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Go To NonPO Downloads Page
    Verify NonPO Downloads Page
    Validate Generate NonPO Report With Random Filters

Validate Rows Per Page On Non-PO Downloads Page
    [Tags]    downloads    rows
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Go To NonPO Downloads Page
    Verify NonPO Downloads Page
    Validate All NonPO Downloads Rows Per Page Options