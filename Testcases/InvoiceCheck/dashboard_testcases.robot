*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/invoice_check_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify Invoice Check Dashboard Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page

Verify Dashboard KPI Cards Count Against Reports
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Validate Dashboard KPI Cards With Reports Count

Validate Dashboard Reconciliation View By Filter
    [Tags]    dashboard    filter
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Validate Reconciliation View By Filters

Validate Dashboard Filters Carry Over To Reports Page
    [Tags]    dashboard    filter
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Validate All Dashboard Filter Combinations

Validate Dashboard Custom Range Filter Carries Over To Reports Page
    [Tags]    dashboard    filter    custom_range
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Validate All Custom Range Filter Combinations

