# =========================
# DATE RANGE PRESET FILTER
# =========================

DATE_PRESET_DROPDOWN        = "xpath=(//button[@data-slot='select-trigger'])[3]"
# DATE_PRESET_LAST_MONTH      = "xpath=//div[@role='option'][normalize-space()='Last Month']"
DATE_PRESET_LAST_MONTH = "xpath=//div[contains(@class,'select-content')]//div[normalize-space()='Last Month'] | //div[@data-state='open']//span[normalize-space()='Last Month']"
# =========================
# REPORTS PAGE FILTERS
# =========================

INVOICE_STATUS_DROPDOWN     = "xpath=//label[contains(.,'Invoice Status')]//following::button[@role='combobox'][1]"

# Invoice Status Options
STATUS_ALL                  = "xpath=//div[@role='option'][normalize-space()='All']"
STATUS_INVOICE_NOT_FOUND    = "xpath=//div[@role='option'][normalize-space()='Invoice Not Found In RSCP']"
STATUS_MATCHED              = "xpath=//div[@role='option'][normalize-space()='Matched']"
STATUS_SUGGESTED_MATCH      = "xpath=//div[@role='option'][normalize-space()='Suggested Match']"
STATUS_EXCEPTION            = "xpath=//div[@role='option'][normalize-space()='Exception']"
STATUS_FAILED               = "xpath=//div[@role='option'][normalize-space()='Failed']"
STATUS_TAX_MISMATCHED       = "xpath=//div[@role='option'][normalize-space()='Tax Mismatched Record']"

# Reports table
REPORTS_STATUS_CELLS        = "xpath=//table//tbody//tr//td[last()-1]"
REPORTS_NEXT_PAGE_BUTTON    = "xpath=//a[@aria-label='Go to next page']"
REPORTS_PAGINATION_TEXT     = "xpath=//p[@aria-live='polite']"
REPORTS_NO_DATA_MESSAGE     = "xpath=//div[@data-slot='empty-title']"
REPORTS_RESET_BUTTON        = "xpath=//button[@title='Reset filters to default']"

# =========================
# ROWS PER PAGE
# =========================

ROWS_PER_PAGE_DROPDOWN      = "xpath=(//button[@role='combobox'])[5]"
ROWS_PER_PAGE_5             = "xpath=//div[@role='option'][normalize-space()='5']"
ROWS_PER_PAGE_10            = "xpath=//div[@role='option'][normalize-space()='10']"
ROWS_PER_PAGE_25            = "xpath=//div[@role='option'][normalize-space()='25']"
ROWS_PER_PAGE_50            = "xpath=//div[@role='option'][normalize-space()='50']"
REPORTS_TABLE_ROWS          = "xpath=//table//tbody//tr"
REPORTS_SHOWING_TEXT        = "xpath=//p[contains(text(),'Showing')]"

# =========================
# INVOICE DETAIL - EDIT & UPDATE STATUS
# =========================

# First invoice link in the reports table
FIRST_INVOICE_LINK          = "xpath=(//table//tbody//tr//td[2]//span[contains(@class,'cursor-pointer')])[1]"

# Edit button on the invoice detail page (OCR Extraction Results section)
EDIT_BUTTON                 = "xpath=//button[normalize-space()='Edit']"

# Save Changes button — appears/enabled after clicking Edit
SAVE_CHANGES_BTN            = "xpath=//button[normalize-space()='Save Changes']"

# Update Status button on the detail page (not inside the popup)
UPDATE_STATUS_BTN           = "xpath=//button[normalize-space()='Update Status'][not(ancestor::*[@data-slot='dialog-content'])]"

# Update Status button INSIDE the confirmation popup
UPDATE_STATUS_POPUP_BTN     = "xpath=//*[@data-slot='dialog-content']//button[normalize-space()='Update Status']"

# Success toast message that appears after saving
SUCCESS_TOAST               = "xpath=//*[normalize-space()='Changes saved successfully']"

# Editable ITC Data input fields (visible only when Edit mode is active)
# TODO: Replace the [INDEX] with the correct number (1 through 19) based on the order on the screen.
# For example, if CGST Amount is the 5th editable input on the screen, change it from [INDEX] to [5]
EDIT_CGST_INPUT             = "xpath=(//input[@data-slot='input' and not(@disabled)])[1]"
EDIT_DOC_TITLE_INPUT        = "xpath=(//input[@data-slot='input' and not(@disabled)])[3]"

# =========================
# SUMMARY PANEL TOGGLE
# =========================

HIDE_SUMMARY_BTN            = "xpath=//button[contains(., 'Hide Summary')]"
SHOW_SUMMARY_BTN            = "xpath=//button[contains(., 'Show Summary')]"
# Look for 'View Invoice' text inside the summary image area as an indicator if the panel is visible or not.
SUMMARY_PANEL_INDICATOR     = "xpath=//*[normalize-space()='View Invoice']"