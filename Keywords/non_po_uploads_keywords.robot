*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    OperatingSystem
Variables    ../Variables/non_po_upload_variables.py
Variables    ../Variables/non_po_invoice_check_variables.py

*** Keywords ***
Go To NonPO Uploads Page
    Wait Until Element Is Visible    ${NONPO_SIDENAV_UPLOADS}    20s
    Click Element                    ${NONPO_SIDENAV_UPLOADS}

Verify NonPO Uploads Page
    Wait Until Location Contains    /non-po/uploads    20s
    Wait Until Element Is Visible   ${NONPO_UPLOADS_TAB_INVOICE}    20s

Select Random Dropdown Option
    [Arguments]    ${dropdown_locator}    ${options_locator}
    Wait Until Element Is Visible    ${dropdown_locator}    15s
    Scroll Element Into View         ${dropdown_locator}
    Sleep    0.5s
    Click Element                    ${dropdown_locator}
    Sleep    2s
    Wait Until Element Is Visible    ${options_locator}    15s
    ${options}=    Get WebElements    ${options_locator}
    ${count}=      Get Length         ${options}
    ${index}=      Evaluate           random.randint(0, ${count} - 1)    modules=random
    Scroll Element Into View          ${options}[${index}]
    Click Element                     ${options}[${index}]
    Sleep    1s

Select Random Reviewer Option
    Wait Until Element Is Visible    ${NONPO_REVIEWER_DROPDOWN}    15s
    Scroll Element Into View         ${NONPO_REVIEWER_DROPDOWN}
    Sleep    0.5s
    Click Element                    ${NONPO_REVIEWER_DROPDOWN}
    Sleep    2s
    Wait Until Page Contains Element    ${NONPO_REVIEWER_OPTIONS}    15s
    ${options}=    Get WebElements    ${NONPO_REVIEWER_OPTIONS}
    ${count}=      Get Length         ${options}
    ${index}=      Evaluate           random.randint(0, ${count} - 1)    modules=random
    Execute Javascript    arguments[0].scrollIntoView({block:'center'});    ARGUMENTS    ${options}[${index}]
    Execute Javascript    arguments[0].click();                              ARGUMENTS    ${options}[${index}]
    Sleep    1s

Upload Files To Invoice Tab
    Sleep   3s
    Wait Until Page Contains Element    ${NONPO_UPLOADS_TAB_INVOICE}    10s
    ${elem}=    Get WebElement       ${NONPO_UPLOADS_TAB_INVOICE}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${elem}
    Sleep    1s
    FOR    ${pdf}    IN    @{INVOICE_PDF_PATHS}
        Choose File    ${NONPO_FILE_INPUT}    ${pdf}
        Sleep    1s
    END

Scroll To Top
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    1s

Upload File To PR Tab
    Scroll To Top
    Sleep    1s

    # Wait Until Element Does Not Exist    ${NONPO_INCOMPLETE_DIALOG}    15s
    Wait Until Element Is Visible        ${NONPO_UPLOADS_TAB_PR}    20s
    Scroll Element Into View             ${NONPO_UPLOADS_TAB_PR}
    Sleep    1s

    ${elem}=    Get WebElement    ${NONPO_UPLOADS_TAB_PR}

    Execute Javascript
    ...    arguments[0].scrollIntoView({block:'center'});
    ...    arguments[0].dispatchEvent(new MouseEvent('mouseover', {bubbles:true}));
    ...    arguments[0].dispatchEvent(new MouseEvent('mousedown', {bubbles:true, button:0}));
    ...    arguments[0].dispatchEvent(new MouseEvent('mouseup', {bubbles:true, button:0}));
    ...    arguments[0].dispatchEvent(new MouseEvent('click', {bubbles:true, button:0}));
    ...    ARGUMENTS    ${elem}

    Sleep    2s

    ${selected}=    Get Element Attribute    ${NONPO_UPLOADS_TAB_PR}    aria-selected
    Log To Console    PR tab aria-selected after click: ${selected}

    Run Keyword If    '${selected}' != 'true'
    ...    Press Keys    ${NONPO_UPLOADS_TAB_PR}    ENTER

    Sleep    2s

    ${selected2}=    Get Element Attribute    ${NONPO_UPLOADS_TAB_PR}    aria-selected
    Log To Console    PR tab aria-selected after ENTER fallback: ${selected2}

    Should Be Equal    ${selected2}    true

    Wait Until Page Contains Element    ${NONPO_ACTIVE_TAB_FILE_INPUT}    15s
    Choose File    ${NONPO_ACTIVE_TAB_FILE_INPUT}    ${PR_PDF_PATH}
    Sleep    2s
# Upload File To PR Tab
#     Sleep   3s
#     Click Element                    ${NONPO_UPLOADS_TAB_PR}
#     Sleep    1s
#     Choose File    ${NONPO_FILE_INPUT}    ${PR_PDF_PATH}
#     Sleep    1s

Fill Upload Form
    Select Random Dropdown Option    ${NONPO_AGREEMENT_DROPDOWN}    ${NONPO_AGREEMENT_OPTIONS}
    Select Random Reviewer Option

Verify Incomplete Upload Dialog
    Wait Until Element Is Visible    ${NONPO_INCOMPLETE_DIALOG}    10s

Click Go Back On Incomplete Dialog
    Wait Until Element Is Visible    ${NONPO_INCOMPLETE_GO_BACK}    10s
    Click Element                    ${NONPO_INCOMPLETE_GO_BACK}
    Sleep    1s

Verify Upload Success Toast
    ${toast_found}=    Run Keyword And Return Status
    ...    Wait Until Keyword Succeeds    20s    1s    Page Should Contain Element    ${NONPO_SUCCESS_TOAST}

    IF    not ${toast_found}
        Capture Page Screenshot
        Log Source
        Fail    Success toast not found after upload.
    END

Verify NonPO Invoice Upload Negative Then Positive
    # --- NEGATIVE: Invoice only, no PR ---
    Upload Files To Invoice Tab
    Fill Upload Form
    Click Element                    ${NONPO_UPLOAD_DOCUMENTS_BTN}
    Verify Incomplete Upload Dialog
    Click Go Back On Incomplete Dialog

    # --- POSITIVE: Now also upload to PR ---
    Upload File To PR Tab
    Fill Upload Form
    Click Element                    ${NONPO_UPLOAD_DOCUMENTS_BTN}
    Verify Upload Success Toast