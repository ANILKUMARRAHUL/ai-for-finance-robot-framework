*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/non_po_dashboard_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify NonPO Invoice Check Dashboard Page
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page

Verify NonPO Dashboard KPI Cards Count Against Reports
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Validate NonPO Dashboard KPI Cards With Reports Count

Validate NonPO Dashboard Reconciliation View By Filter
    [Tags]    dashboard    filter
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Validate NonPO Reconciliation View By Filters

Validate NonPO Dashboard Filters Carry Over To Reports Page
    [Tags]    dashboard    filter
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Validate All NonPO Dashboard Filter Combinations

Validate NonPO Dashboard Custom Month Range Filter Carries Over To Reports Page
    [Tags]    dashboard    filter    custom_month_range
    Login To Application    ${VALID_NON_PO_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Go To NonPO Dashboard Page
    Verify NonPO Dashboard Page
    Validate All NonPO Dashboard Custom Month Range Combinations

# Validate NonPO Dashboard Custom Range Filter Carries Over To Reports Page
#     [Tags]    dashboard    filter    custom_range
#     Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
#     Verify Login Successful
#     Verify Home Page Loaded
#     Go To NonPO Dashboard Page
#     Verify NonPO Dashboard Page
#     Validate All NonPO Custom Range Filter Combinations
