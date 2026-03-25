*** Settings ***
Library    SeleniumLibrary
Variables  ../Variables/login_variables.py

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Terminate Browser Session
    Close Browser