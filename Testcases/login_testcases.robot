*** Settings ***
Resource    ../Settings/Settings.robot
Resource    ../Keywords/login_keywords.robot

Test Setup       Open Browser With Options
Test Teardown    Terminate Browser Session

*** Test Cases ***
Verify Valid Login
    Log To Console    Thread ID: ${TEST NAME}
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Successful

Verify Invalid Login
    Log To Console    Thread ID: ${TEST NAME}
    Login To Application    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    ${error}=    Get Login Error Message
    Should Contain    ${error}    Login failed