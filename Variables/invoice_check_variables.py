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