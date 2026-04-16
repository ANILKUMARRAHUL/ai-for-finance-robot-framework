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

# DASHBOARD_KPI_CARDS = "xpath=//main//div[contains(@class,'h-full') and contains(@class,'cursor-pointer')]"
# CARD_TITLE_RELATIVE = "xpath=.//div[contains(@class,'uppercase')]"
# CARD_VALUE_RELATIVE = "xpath=.//div[contains(@class,'text-4xl')]"
DASHBOARD_KPI_CARDS     = "xpath=//main//div[contains(@class,'h-full') and contains(@class,'bg-card')]"
CARD_TITLE_RELATIVE     = "xpath=.//div[contains(@class,'uppercase')]"
CARD_VALUE_RELATIVE     = "xpath=.//div[contains(@class,'text-2xl')]"

# Excluded cards
EXCLUDED_CARD_1 = "ITC RECEIVED"
EXCLUDED_CARD_2 = "OCR FAILED"
EXCLUDED_CARD_3 = "INVOICE NOT FOUND IN ITC"

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
# =========================
# CUSTOM RANGE DATE PICKER
# =========================
# DATE_RANGE_CUSTOM_RANGE = "xpath=//div[@role='option'][normalize-space()='Custom Range']"
# New options
DATE_RANGE_CUSTOM_MONTH_RANGE   = "xpath=//div[@role='option'][normalize-space()='Custom Month Range']"
DATE_RANGE_CUSTOM_DATE_RANGE    = "xpath=//div[@role='option'][normalize-space()='Custom Date Range']"
# Custom Month Range picker
# CUSTOM_MONTH_FROM_MONTH         = "xpath=(//button[@role='combobox'])[4]"
# CUSTOM_MONTH_FROM_YEAR          = "xpath=(//button[@role='combobox'])[5]"
# CUSTOM_MONTH_TO_MONTH           = "xpath=(//button[@role='combobox'])[6]"
# CUSTOM_MONTH_TO_YEAR            = "xpath=(//button[@role='combobox'])[7]"
# CUSTOM_MONTH_APPLY_BUTTON       = "xpath=//button[normalize-space()='Apply']"
CUSTOM_MONTH_FROM_MONTH = "xpath=//div[@data-slot='popover-content']//div[./label[normalize-space()='From Month']]//button[@role='combobox']"
CUSTOM_MONTH_FROM_YEAR  = "xpath=//div[@data-slot='popover-content']//div[./label[normalize-space()='From Year']]//button[@role='combobox']"
CUSTOM_MONTH_TO_MONTH   = "xpath=//div[@data-slot='popover-content']//div[./label[normalize-space()='To Month']]//button[@role='combobox']"
CUSTOM_MONTH_TO_YEAR    = "xpath=//div[@data-slot='popover-content']//div[./label[normalize-space()='To Year']]//button[@role='combobox']"
CUSTOM_MONTH_APPLY_BUTTON = "xpath=//div[@data-slot='popover-content']//button[normalize-space()='Apply']"

CUSTOM_RANGE_APPLY_BUTTON = "xpath=//button[normalize-space()='Apply']"
CUSTOM_RANGE_CANCEL_BUTTON = "xpath=//button[normalize-space()='Cancel']"
DASHBOARD_NO_DATA_MESSAGE = "xpath=//h3[normalize-space()='No Data Available']"
CARD_TOOLTIP = "xpath=//div[contains(text(),'Exact Value:')]"
CUSTOM_RANGE_DATE_TRIGGER = "xpath=//button[@data-slot='popover-trigger' and @aria-haspopup='dialog']"
