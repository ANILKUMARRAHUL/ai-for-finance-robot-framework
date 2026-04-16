# =========================
# DOWNLOADS PAGE
# =========================

DOWNLOADS_HEADING               = "xpath=//main//h1[normalize-space()='Downloads']"

# Filter Dropdowns
REPORT_TYPE_DROPDOWN            = "xpath=(//button[@role='combobox'])[1]"
STATE_CODE_DROPDOWN             = "xpath=(//button[@role='combobox'])[2]"
SUPPLIER_DROPDOWN               = "xpath=(//button[@role='combobox'])[3]"
VOUCHER_CODE_DROPDOWN           = "xpath=(//button[@role='combobox'])[4]"
# DOWNLOADS_DATE_COLUMN_DROPDOWN  = "xpath=(//button[@role='combobox'])[5]"
DOWNLOADS_DATE_COLUMN_DROPDOWN  = "xpath=//label[contains(.,'Date Column')]/following::button[@role='combobox'][1]"
DOWNLOADS_DATE_RANGE_DROPDOWN   = "xpath=//label[contains(.,'Voucher Date Range')]/following::button[@role='combobox'][1]"
DOWNLOADS_INVOICE_DATE_RANGE_DROPDOWN = "xpath=//label[contains(.,'Invoice Date Range')]/following::button[@role='combobox'][1]"
# Dropdown options
DROPDOWN_OPTIONS                = "xpath=//div[@role='option']"
VOUCHER_CODE_OPTIONS            = "xpath=//div[@data-slot='command-item']"
DOWNLOADS_VOUCHER_DATE_RANGE_DROPDOWN = "xpath=//label[contains(.,'Voucher Date Range')]/following::button[@role='combobox'][1]"
DOWNLOADS_INVOICE_DATE_RANGE_DROPDOWN = "xpath=//label[contains(.,'Invoice Date Range')]/following::button[@role='combobox'][1]"
ALL_ENABLED_DAYS                = "xpath=//button[contains(@class,'rdp-day_button') and not(@disabled)]"    
# Date Column Options
DOWNLOADS_DATE_COLUMN_INVOICE   = "xpath=//div[@role='option'][normalize-space()='Invoice Date']"
DOWNLOADS_DATE_COLUMN_VOUCHER   = "xpath=//div[@role='option'][normalize-space()='Voucher Date']"

# Date Range Options (excluding Custom Range)
DOWNLOADS_DATE_RANGE_MONTH      = "xpath=//div[@role='option'][normalize-space()='Month Till Date']"
# DOWNLOADS_DATE_RANGE_YEAR       = "xpath=//div[@role='option'][normalize-space()='Year Till Date']"
DOWNLOADS_DATE_RANGE_LAST_MONTH = "xpath=//div[@role='option'][normalize-space()='Last Month']"
# DOWNLOADS_DATE_RANGE_FISCAL     = "xpath=//div[@role='option'][normalize-space()='Fiscal Year']"

# Generate Report
GENERATE_REPORT_BUTTON          = "xpath=//button[normalize-space()='Generate Report']"

# Toast message
REPORT_GENERATION_TOAST         = "xpath=//div[@data-title][contains(.,'Report generation started')]"
# =========================
# DOWNLOADS ROWS PER PAGE
# =========================

DOWNLOADS_ROWS_PER_PAGE_DROPDOWN    = "xpath=(//button[@role='combobox'])[5]"
DOWNLOADS_ROWS_PER_PAGE_5           = "xpath=//div[@role='option'][normalize-space()='5']"
DOWNLOADS_ROWS_PER_PAGE_10          = "xpath=//div[@role='option'][normalize-space()='10']"
DOWNLOADS_ROWS_PER_PAGE_25          = "xpath=//div[@role='option'][normalize-space()='25']"
DOWNLOADS_ROWS_PER_PAGE_50          = "xpath=//div[@role='option'][normalize-space()='50']"
DOWNLOADS_TABLE_ROWS                = "xpath=//table//tbody//tr"
DOWNLOADS_SHOWING_TEXT              = "xpath=//p[contains(text(),'Showing')]"
DOWNLOADS_NO_DATA_MESSAGE = "xpath=//div[normalize-space()='No Reports Found']"