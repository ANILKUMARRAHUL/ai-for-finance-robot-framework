# =========================
# NON-PO DOWNLOADS PAGE
# =========================

NONPO_DOWNLOADS_HEADING               = "xpath=//main//h1[normalize-space()='Downloads']"

# Filter Dropdowns
NONPO_REPORT_TYPE_DROPDOWN            = "xpath=(//button[@role='combobox'])[1]"
NONPO_SUPPLIER_DROPDOWN               = "xpath=(//button[@role='combobox'])[2]"
NONPO_DOWNLOADS_DATE_COLUMN_DROPDOWN  = "xpath=(//button[@role='combobox'])[3]"
NONPO_DOWNLOADS_DATE_RANGE_DROPDOWN   = "xpath=(//button[@role='combobox'])[4]"

# Dropdown options
NONPO_DROPDOWN_OPTIONS                = "xpath=//div[@role='option']"
NONPO_SUPPLIER_OPTIONS                = "xpath=//div[@data-slot='command-item']"

# Date Column Options
NONPO_DOWNLOADS_DATE_COLUMN_UPLOAD    = "xpath=//div[@role='option'][normalize-space()='Upload Date']"
NONPO_DOWNLOADS_DATE_COLUMN_INVOICE   = "xpath=//div[@role='option'][normalize-space()='Invoice Date']"

# Date Range Options (excluding Custom Range)
NONPO_DOWNLOADS_DATE_RANGE_MONTH      = "xpath=//div[@role='option'][normalize-space()='Month Till Date']"
NONPO_DOWNLOADS_DATE_RANGE_YEAR       = "xpath=//div[@role='option'][normalize-space()='Year Till Date']"
NONPO_DOWNLOADS_DATE_RANGE_LAST_MONTH = "xpath=//div[@role='option'][normalize-space()='Last Month']"
NONPO_DOWNLOADS_DATE_RANGE_FISCAL     = "xpath=//div[@role='option'][normalize-space()='Fiscal Year']"

# Generate Report
NONPO_GENERATE_REPORT_BUTTON          = "xpath=//button[normalize-space()='Generate Report']"

# Toast message
NONPO_REPORT_GENERATION_TOAST         = "xpath=//div[@data-title][contains(.,'Report created and processing started')]"

# =========================
# DOWNLOADS ROWS PER PAGE
# =========================

NONPO_DOWNLOADS_ROWS_PER_PAGE_DROPDOWN    = "xpath=(//button[@role='combobox'])[5]"
NONPO_DOWNLOADS_ROWS_PER_PAGE_6           = "xpath=//div[@role='option'][normalize-space()='6']"
NONPO_DOWNLOADS_ROWS_PER_PAGE_12          = "xpath=//div[@role='option'][normalize-space()='12']"
NONPO_DOWNLOADS_ROWS_PER_PAGE_24          = "xpath=//div[@role='option'][normalize-space()='24']"
NONPO_DOWNLOADS_ROWS_PER_PAGE_48          = "xpath=//div[@role='option'][normalize-space()='48']"
NONPO_DOWNLOADS_TABLE_ROWS                = "xpath=//table//tbody//tr"
NONPO_DOWNLOADS_SHOWING_TEXT              = "xpath=//p[contains(text(),'Showing')]"
NONPO_DOWNLOADS_NO_DATA_MESSAGE = "xpath=//div[normalize-space()='No Reports Found']"
