# =========================
# DOWNLOADS PAGE
# =========================

DOWNLOADS_HEADING               = "xpath=//main//h1[normalize-space()='Downloads']"

# Filter Dropdowns
REPORT_TYPE_DROPDOWN            = "xpath=(//button[@role='combobox'])[1]"
STATE_CODE_DROPDOWN             = "xpath=(//button[@role='combobox'])[2]"
SUPPLIER_DROPDOWN               = "xpath=(//button[@role='combobox'])[3]"
VOUCHER_CODE_DROPDOWN           = "xpath=(//button[@role='combobox'])[4]"
DOWNLOADS_DATE_COLUMN_DROPDOWN  = "xpath=(//button[@role='combobox'])[5]"
DOWNLOADS_DATE_RANGE_DROPDOWN   = "xpath=(//button[@role='combobox'])[6]"

# Dropdown options
DROPDOWN_OPTIONS                = "xpath=//div[@role='option']"
VOUCHER_CODE_OPTIONS            = "xpath=//div[@data-slot='command-item']"

# Date Column Options
DOWNLOADS_DATE_COLUMN_INVOICE   = "xpath=//div[@role='option'][normalize-space()='Invoice Date']"
DOWNLOADS_DATE_COLUMN_VOUCHER   = "xpath=//div[@role='option'][normalize-space()='Voucher Date']"

# Date Range Options (excluding Custom Range)
DOWNLOADS_DATE_RANGE_MONTH      = "xpath=//div[@role='option'][normalize-space()='Month Till Date']"
DOWNLOADS_DATE_RANGE_YEAR       = "xpath=//div[@role='option'][normalize-space()='Year Till Date']"
DOWNLOADS_DATE_RANGE_LAST_MONTH = "xpath=//div[@role='option'][normalize-space()='Last Month']"
DOWNLOADS_DATE_RANGE_FISCAL     = "xpath=//div[@role='option'][normalize-space()='Fiscal Year']"

# Generate Report
GENERATE_REPORT_BUTTON          = "xpath=//button[normalize-space()='Generate Report']"

# Toast message
REPORT_GENERATION_TOAST         = "xpath=//div[@data-title][contains(.,'Report generation started')]"
# =========================
# DOWNLOADS ROWS PER PAGE
# =========================

DOWNLOADS_ROWS_PER_PAGE_DROPDOWN    = "xpath=(//button[@role='combobox'])[7]"
DOWNLOADS_ROWS_PER_PAGE_6           = "xpath=//div[@role='option'][normalize-space()='6']"
DOWNLOADS_ROWS_PER_PAGE_12          = "xpath=//div[@role='option'][normalize-space()='12']"
DOWNLOADS_ROWS_PER_PAGE_24          = "xpath=//div[@role='option'][normalize-space()='24']"
DOWNLOADS_ROWS_PER_PAGE_48          = "xpath=//div[@role='option'][normalize-space()='48']"
DOWNLOADS_TABLE_ROWS                = "xpath=//table//tbody//tr"
DOWNLOADS_SHOWING_TEXT              = "xpath=//p[contains(text(),'Showing')]"
DOWNLOADS_NO_DATA_MESSAGE = "xpath=//div[normalize-space()='No Reports Found']"