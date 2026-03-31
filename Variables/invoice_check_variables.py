# Sidebar
SIDENAV_DASHBOARD = "xpath=//a[contains(@href,'/invoice-check/dashboard') and contains(.,'Dashboard')]"
SIDENAV_REPORTS = "xpath=//a[contains(@href,'/invoice-check/reports') and contains(.,'Reports')]"
SIDENAV_DOWNLOADS = "xpath=//a[contains(@href,'/invoice-check/downloads') and contains(.,'Downloads')]"

# Page headings
DASHBOARD_HEADING = "xpath=//main//h1[normalize-space()='Invoice Check Overview']"
REPORTS_HEADING = "xpath=//main//h1[normalize-space()='Reports']"
DOWNLOADS_HEADING = "xpath=//main//h1[normalize-space()='Downloads']"

# Common module verification
INVOICE_CHECK_MODULE_LOADED = "xpath=//a[contains(@href,'/invoice-check/dashboard') and contains(.,'Dashboard')]"

# =========================
# DASHBOARD KPI CARDS
# =========================

DASHBOARD_KPI_CARDS = "xpath=//main//div[contains(@class,'h-40') and contains(@class,'cursor-pointer')]"
CARD_TITLE_RELATIVE = "xpath=.//div[contains(@class,'uppercase')]"
CARD_VALUE_RELATIVE = "xpath=.//div[contains(@class,'text-4xl')]"

# Excluded cards
EXCLUDED_CARD_1 = "ITC RECEIVED"
EXCLUDED_CARD_2 = "FAILED"

# Reports bottom count
REPORTS_BOTTOM_TOTAL = "xpath=//main//p[@aria-live='polite']//span[last()]"

RECON_TABLE_HEADING = "xpath=//div[normalize-space()='Reconciliation Outcomes Over Time']"
VIEW_BY_DROPDOWN = "xpath=(//button[@role='combobox'])[3]"

VIEW_BY_MONTH_OPTION = "xpath=//div[@role='option'][normalize-space()='Month']"
VIEW_BY_QUARTER_OPTION = "xpath=//div[@role='option'][normalize-space()='Quarter']"
VIEW_BY_YEAR_OPTION = "xpath=//div[@role='option'][normalize-space()='Year']"

RECON_DYNAMIC_COLUMN_HEADER = "xpath=(//table//thead//th[normalize-space()='Outcome']/following-sibling::th)[1]"

# =========================
# DASHBOARD FILTER DROPDOWNS
# =========================

DATE_COLUMN_DROPDOWN = "xpath=(//button[@role='combobox'])[1]"
DATE_RANGE_DROPDOWN = "xpath=(//button[@role='combobox'])[2]"

# Date Column Options
DATE_COLUMN_INVOICE_DATE = "xpath=//div[@role='option'][normalize-space()='Invoice Date']"
DATE_COLUMN_VOUCHER_DATE = "xpath=//div[@role='option'][normalize-space()='Voucher Date']"

# Date Range Options
DATE_RANGE_MONTH_TILL_DATE = "xpath=//div[@role='option'][normalize-space()='Month Till Date']"
DATE_RANGE_LAST_MONTH     = "xpath=//div[@role='option'][normalize-space()='Last Month']"
DATE_RANGE_FISCAL_YEAR    = "xpath=//div[@role='option'][normalize-space()='Fiscal Year']"
DATE_RANGE_YEAR_TILL_DATE = "xpath=//div[@role='option'][normalize-space()='Year Till Date']"

# URL parameter mappings are handled in keywords directly

# =========================
# CUSTOM RANGE DATE PICKER
# =========================
DATE_RANGE_CUSTOM_RANGE = "xpath=//div[@role='option'][normalize-space()='Custom Range']"
CUSTOM_RANGE_APPLY_BUTTON = "xpath=//button[normalize-space()='Apply']"
CUSTOM_RANGE_CANCEL_BUTTON = "xpath=//button[normalize-space()='Cancel']"
DASHBOARD_NO_DATA_MESSAGE = "xpath=//h3[normalize-space()='No Data Available']"
CARD_TOOLTIP = "xpath=//div[contains(text(),'Exact Value:')]"
