*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Variables    ../Variables/invoice_check_variables.py

*** Keywords ***
# Open Invoice Check Module
#     Wait Until Page Contains Element    xpath=//a[contains(@href,'/invoice-check/')]    20s
#     Click Element    xpath=//a[contains(@href,'/invoice-check/')]

Go To Dashboard Page
    Wait Until Element Is Visible    ${SIDENAV_DASHBOARD}    20s
    Click Element    ${SIDENAV_DASHBOARD}

Verify Dashboard Page
    Wait Until Location Contains    /invoice-check/dashboard    20s
    Wait Until Element Is Visible    ${DASHBOARD_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Go To Reports Page
    Wait Until Element Is Visible    ${SIDENAV_REPORTS}    20s
    Click Element    ${SIDENAV_REPORTS}

Verify Reports Page
    Wait Until Location Contains    /invoice-check/reports    20s
    Wait Until Element Is Visible    ${REPORTS_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Go To Downloads Page
    Wait Until Element Is Visible    ${SIDENAV_DOWNLOADS}    20s
    Click Element    ${SIDENAV_DOWNLOADS}

Verify Downloads Page
    Wait Until Location Contains    /invoice-check/downloads    20s
    Wait Until Element Is Visible    ${DOWNLOADS_HEADING}    20s
    Wait For Page To Stabilize
    Slow Scroll To Bottom

Slow Scroll To Bottom
    ${height}=    Execute JavaScript    return document.body.scrollHeight
    FOR    ${i}    IN RANGE    0    ${height}    400
        Execute JavaScript    window.scrollTo(0, ${i})
        Sleep    0.4s
    END
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Wait For Page To Stabilize
    Sleep    2s

Clean Number Text
    [Arguments]    ${text}
    ${clean}=    Replace String Using Regexp    ${text}    [, ]    ${EMPTY}
    RETURN    ${clean}
    
Validate Dashboard KPI Cards With Reports Count
    Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s
    ${cards}=    Get WebElements    ${DASHBOARD_KPI_CARDS}
    ${total_cards}=    Get Length    ${cards}

    FOR    ${index}    IN RANGE    ${total_cards}
        ${position}=    Evaluate    ${index} + 1

        Wait Until Element Is Visible    ${DASHBOARD_KPI_CARDS}    20s

        ${title_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]//div[contains(@class,'uppercase')]
        ${value_locator}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]//div[contains(@class,'text-4xl')]
        ${click_card}=    Set Variable    xpath=(//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')])[${position}]

        ${title}=    Get Text    ${title_locator}
        ${title}=    Convert To Upper Case    ${title}
        ${value}=    Get Text    ${value_locator}
        ${dashboard_count}=    Clean Number Text    ${value}

        Log To Console    \nChecking card: ${title} = ${dashboard_count}

        IF    '${title}' == '${EXCLUDED_CARD_1}' or '${title}' == '${EXCLUDED_CARD_2}'
            Log To Console    Skipping card: ${title}
            CONTINUE
        END

        Scroll Element Into View    ${click_card}
        Sleep    1s
        Click Element    ${click_card}

        Wait Until Location Contains    /invoice-check/reports    20s
        Wait Until Element Is Visible    ${REPORTS_BOTTOM_TOTAL}    20s

        Slow Scroll To Bottom

        ${reports_total}=    Get Text    ${REPORTS_BOTTOM_TOTAL}
        ${reports_count}=    Clean Number Text    ${reports_total}

        Log To Console    Reports total: ${reports_count}

        Should Be Equal    ${dashboard_count}    ${reports_count}

        Go Back
        Wait Until Location Contains    /invoice-check/dashboard    20s
        Wait Until Element Is Visible    ${DASHBOARD_HEADING}    20s
        Scroll To Top
        Wait For Page To Stabilize
    END

Scroll To Reconciliation Table
    Wait Until Element Is Visible    ${RECON_TABLE_HEADING}    20s
    Scroll Element Into View         ${RECON_TABLE_HEADING}
    Sleep    2s

Open View By Dropdown
    Wait Until Element Is Visible    ${VIEW_BY_DROPDOWN}    20s
    Scroll Element Into View         ${VIEW_BY_DROPDOWN}
    Sleep    1s
    Click Element                    ${VIEW_BY_DROPDOWN}
    Sleep    2s

Select View By Option
    [Arguments]    ${option_locator}

    Wait Until Element Is Visible    ${option_locator}    10s
    Click Element                    ${option_locator}
    Sleep    2s

Get Reconciliation Column Header
    Wait Until Element Is Visible    ${RECON_DYNAMIC_COLUMN_HEADER}    20s
    ${header}=    Get Text    ${RECON_DYNAMIC_COLUMN_HEADER}
    Log To Console    \nColumn Header: ${header}
    RETURN    ${header}

Validate View By Filter Change
    [Arguments]    ${filter_name}    ${option_locator}    ${expected_keyword}

    Log To Console    \n--- Checking Filter: ${filter_name} ---

    Open View By Dropdown
    Select View By Option    ${option_locator}

    ${header}=    Get Reconciliation Column Header

    Should Contain    ${header}    ${expected_keyword}

Validate Reconciliation View By Filters
    Scroll To Reconciliation Table
    Validate View By Filter Change    Month      ${VIEW_BY_MONTH_OPTION}      (
    Validate View By Filter Change    Quarter    ${VIEW_BY_QUARTER_OPTION}    Q
    Validate View By Filter Change    Year       ${VIEW_BY_YEAR_OPTION}       20