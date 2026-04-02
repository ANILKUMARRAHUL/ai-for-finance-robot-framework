*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/invoice_check_keywords.robot
Resource    ../../Keywords/download_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify Invoice Check Downloads Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Go To Downloads Page
    Verify Downloads Page

Validate Generate Report With Random Filters On Downloads Page
    [Tags]    downloads    filter    generate
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Go To Downloads Page
    Verify Downloads Page
    Validate Generate Report With Random Filters

Validate Rows Per Page On Downloads Page
    [Tags]    downloads    rows
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful
    Verify Home Page Loaded
    Open Invoice Check Module
    Verify Dashboard Page
    Go To Downloads Page
    Verify Downloads Page
    Validate All Downloads Rows Per Page Options