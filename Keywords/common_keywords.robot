*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Slow Scroll To Bottom
    FOR    ${i}    IN RANGE    15
        Execute JavaScript    window.scrollBy(0, 500)
        Sleep    1s
    END


