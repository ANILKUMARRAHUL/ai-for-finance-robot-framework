# =========================
# NON-PO SIDEBAR
# =========================
NONPO_SIDENAV_DASHBOARD     = "xpath=//span[normalize-space()='Dashboard']"
NONPO_SIDENAV_UPLOADS       = "xpath=//span[normalize-space()='Uploads']"
NONPO_SIDENAV_REPORTS       = "xpath=//span[normalize-space()='Reports']"
NONPO_SIDENAV_DOWNLOADS     = "xpath=//span[normalize-space()='Downloads']"

# =========================
# PAGE HEADINGS
# =========================
NONPO_DASHBOARD_HEADING     = "xpath=//h1[normalize-space()='Non PO Invoice Overview']"
NONPO_REPORTS_HEADING       = "xpath=//h1[normalize-space()='Reports']"
NONPO_DOWNLOADS_HEADING     = "xpath=//h1[normalize-space()='Downloads']"

# =========================
# DASHBOARD KPI CARDS
# =========================
NONPO_DASHBOARD_KPI_CARDS   = "xpath=//main//div[contains(@class,'h-full') and contains(@class,'bg-card') and contains(@class,'rounded-xl')]"

# =========================
# DASHBOARD FILTER DROPDOWNS
# =========================
NONPO_DATE_COLUMN_DROPDOWN  = "xpath=(//button[@role='combobox'])[1]"
NONPO_DATE_RANGE_DROPDOWN   = "xpath=(//button[@role='combobox'])[2]"

# Date Column Options
NONPO_DATE_COLUMN_UPLOAD    = "xpath=//div[@role='option'][normalize-space()='Upload Date']"
NONPO_DATE_COLUMN_INVOICE   = "xpath=//div[@role='option'][normalize-space()='Invoice Date']"

# Date Range Options
NONPO_DATE_RANGE_MONTH      = "xpath=//div[@role='option'][normalize-space()='Month Till Date']"
NONPO_DATE_RANGE_YEAR       = "xpath=//div[@role='option'][normalize-space()='Year Till Date']"
NONPO_DATE_RANGE_LAST_MONTH = "xpath=//div[@role='option'][normalize-space()='Last Month']"
NONPO_DATE_RANGE_FISCAL     = "xpath=//div[@role='option'][normalize-space()='Fiscal Year']"
# NONPO_DATE_RANGE_CUSTOM     = "xpath=//div[@role='option'][normalize-space()='Custom Range']"

# Custom Range
NONPO_CUSTOM_RANGE_APPLY    = "xpath=//button[normalize-space()='Apply']"
NONPO_DATE_TRIGGER          = "xpath=//button[@data-slot='popover-trigger' and @aria-haspopup='dialog']"
NONPO_NO_DATA_MESSAGE       = "xpath=//h3[normalize-space()='No Data Available']"
# New options
NONPO_DATE_RANGE_CUSTOM_MONTH   = "xpath=//div[@role='option'][normalize-space()='Custom Month Range']"
NONPO_DATE_RANGE_CUSTOM_DATE    = "xpath=//div[@role='option'][normalize-space()='Custom Date Range']"

# Custom Month Range picker
NONPO_CUSTOM_MONTH_FROM_MONTH   = "xpath=(//button[@role='combobox'])[4]"
NONPO_CUSTOM_MONTH_FROM_YEAR    = "xpath=(//button[@role='combobox'])[5]"
NONPO_CUSTOM_MONTH_TO_MONTH     = "xpath=(//button[@role='combobox'])[6]"
NONPO_CUSTOM_MONTH_TO_YEAR      = "xpath=(//button[@role='combobox'])[7]"
NONPO_CUSTOM_MONTH_APPLY        = "xpath=//button[normalize-space()='Apply']"
# =========================
# RECONCILIATION TABLE
# =========================
NONPO_RECON_TABLE_HEADING       = "xpath=//div[normalize-space()='Reconciliation Outcomes Over Time']"
NONPO_VIEW_BY_DROPDOWN          = "xpath=(//button[@role='combobox'])[3]"
NONPO_VIEW_BY_MONTH_OPTION      = "xpath=//div[@role='option'][normalize-space()='Month']"
NONPO_VIEW_BY_QUARTER_OPTION    = "xpath=//div[@role='option'][normalize-space()='Quarter']"
NONPO_VIEW_BY_YEAR_OPTION       = "xpath=//div[@role='option'][normalize-space()='Year']"
NONPO_RECON_COLUMN_HEADER       = "xpath=(//table//thead//th[normalize-space()='Outcome']/following-sibling::th)[1]"

# =========================
# REPORTS
# =========================
NONPO_REPORTS_BOTTOM_TOTAL  = "xpath=//p[contains(text(),'Showing')]//span[last()]"