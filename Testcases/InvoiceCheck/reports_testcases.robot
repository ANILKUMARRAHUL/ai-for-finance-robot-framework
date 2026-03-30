*** Settings ***
Resource    ../../Settings/settings.robot
Resource    ../../Keywords/login_keywords.robot
Resource    ../../Keywords/home_keywords.robot
Resource    ../../Keywords/invoice_check_keywords.robot

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