*** Settings ***
Library     SeleniumLibrary
Variables   ../Variables/home_variables.py

*** Keywords ***
Verify Home Page Loaded
    Wait Until Element Is Visible    ${HOME_PAGE_TITLE}    40s
    Wait Until Element Is Visible    ${OPEN_INVOICE_CHECK_BUTTON}    40s

Open Invoice Check Module
    Wait Until Element Is Visible    ${OPEN_INVOICE_CHECK_BUTTON}    20s
    Scroll Element Into View         ${OPEN_INVOICE_CHECK_BUTTON}
    Click Element                    ${OPEN_INVOICE_CHECK_BUTTON}