*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/invoice_check_keywords.robot
Resource    ../../Keywords/report_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify Invoice Check Reports Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful

    Verify Home Page Loaded
    Open Invoice Check Module

    Verify Dashboard Page
    Go To Reports Page
    Verify Reports Page

Validate Invoice Status Filter On Reports Page
    [Tags]    reports    filter    status
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Go To Reports Page
    Verify Reports Page
    Validate All Invoice Status Filters

Validate Rows Per Page On Reports Page
    [Tags]    reports    filter    rows
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Go To Reports Page
    Verify Reports Page
    Validate All Rows Per Page Options