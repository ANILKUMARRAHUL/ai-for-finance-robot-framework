# =========================
# REPORTS PAGE FILTERS
# =========================

INVOICE_STATUS_DROPDOWN     = "xpath=(//button[@role='combobox'])[3]"

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

ROWS_PER_PAGE_DROPDOWN      = "xpath=(//button[@role='combobox'])[4]"
ROWS_PER_PAGE_5             = "xpath=//div[@role='option'][normalize-space()='5']"
ROWS_PER_PAGE_10            = "xpath=//div[@role='option'][normalize-space()='10']"
ROWS_PER_PAGE_25            = "xpath=//div[@role='option'][normalize-space()='25']"
ROWS_PER_PAGE_50            = "xpath=//div[@role='option'][normalize-space()='50']"
REPORTS_TABLE_ROWS          = "xpath=//table//tbody//tr"
REPORTS_SHOWING_TEXT        = "xpath=//p[contains(text(),'Showing')]"