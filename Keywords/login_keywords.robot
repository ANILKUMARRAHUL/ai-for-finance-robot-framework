*** Settings ***
Library    SeleniumLibrary
Variables    ../Variables/login_variables.py

*** Keywords ***
Enter Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${USERNAME_FIELD}
    Input Text    ${USERNAME_FIELD}    ${username}

Enter Password
    [Arguments]    ${password}
    Input Text    ${PASSWORD_FIELD}    ${password}

Click Login
    Click Button    ${LOGIN_BUTTON}

Login To Application
    [Arguments]    ${username}    ${password}
    Enter Username    ${username}
    Enter Password    ${password}
    Click Login
    Sleep    3s

Verify Login Successful
    Wait Until Location Contains    ai-finance.tkm.co.in/

Get Login Error Message
    Wait Until Element Is Visible    ${ERROR_TOAST}
    ${msg}=    Get Text    ${ERROR_TOAST}
    RETURN    ${msg}