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
    Click Element                    ${NONPO_UPLOADS_TAB_INVOICE}
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
    Wait Until Element Is Visible    ${NONPO_UPLOADS_TAB_PR}    10s
    Scroll Element Into View         ${NONPO_UPLOADS_TAB_PR}
    Sleep    1s
    # Execute JavaScript    document.querySelector('[id*="trigger-payment-request"]').click()
    Click Element                    ${NONPO_UPLOADS_TAB_PR}
    Sleep    2s
    Choose File    ${NONPO_FILE_INPUT}    ${PR_PDF_PATH}
    Sleep    1s
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
    Wait Until Element Is Visible    ${NONPO_SUCCESS_TOAST}    10s

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