# =========================
# NON-PO REPORTS PAGE
# =========================

# ── TABS ──────────────────────────────────────────────────────────────
NONPO_REPORTS_TAB_PAYMENT_REQUESTS  = "xpath=//button[@role='tab'][normalize-space()='Payment Requests']"
NONPO_REPORTS_TAB_INVOICES          = "xpath=//button[@role='tab'][normalize-space()='Invoices']"

# ── COLUMNS BUTTON ─────────────────────────────────────────────────────
# The "Columns X/X" button that opens the manage-columns popover
# It has aria-label='Manage columns' on the button itself
NONPO_REPORTS_COLUMNS_BTN           = "xpath=//button[@aria-label='Manage columns' or (contains(.,'Columns') and @aria-haspopup='dialog')]"

# Each toggle row inside the open columns popover.
# Radix UI renders column toggles as <button role='checkbox'> inside the popover content.
# The popover content is a div with data-slot='popover-content' OR data-state='open'.
# Using the broadest safe selector: any button[role='checkbox'] that is currently visible.
NONPO_REPORTS_COLUMN_ITEMS          = "xpath=//div[@data-slot='popover-content']//button[@role='checkbox'] | //div[@data-state='open' and not(@role)]//button[@role='checkbox']"

# Reset button inside the manage-columns popover
NONPO_REPORTS_COLUMNS_RESET         = "xpath=//div[@data-slot='popover-content']//button[normalize-space()='Reset'] | //div[@data-state='open']//button[normalize-space()='Reset']"

# ── PAGINATION – PAYMENT REQUESTS TAB ─────────────────────────────────
# "Rows per page" dropdown (Payment Requests tab only – combobox in footer)
NONPO_PR_ROWS_PER_PAGE_DROPDOWN     = "xpath=(//button[@role='combobox'])[last()]"
NONPO_PR_ROWS_PER_PAGE_5            = "xpath=//div[@role='option'][normalize-space()='5']"
NONPO_PR_ROWS_PER_PAGE_10           = "xpath=//div[@role='option'][normalize-space()='10']"
NONPO_PR_ROWS_PER_PAGE_25           = "xpath=//div[@role='option'][normalize-space()='25']"
NONPO_PR_ROWS_PER_PAGE_50           = "xpath=//div[@role='option'][normalize-space()='50']"
NONPO_PR_TABLE_ROWS                 = "xpath=//table//tbody//tr"
NONPO_PR_SHOWING_TEXT               = "xpath=//p[contains(.,'Showing') and contains(.,'payment request')]"
NONPO_PR_NEXT_PAGE_BTN              = "xpath=//a[@aria-label='Go to next page']"
NONPO_PR_PREV_PAGE_BTN              = "xpath=//a[@aria-label='Go to previous page']"

# ── PAGINATION – INVOICES TAB ──────────────────────────────────────────
NONPO_INV_ROWS_PER_PAGE_DROPDOWN    = "xpath=(//button[@role='combobox'])[last()]"
NONPO_INV_ROWS_PER_PAGE_5           = "xpath=//div[@role='option'][normalize-space()='5']"
NONPO_INV_ROWS_PER_PAGE_10          = "xpath=//div[@role='option'][normalize-space()='10']"
NONPO_INV_ROWS_PER_PAGE_25          = "xpath=//div[@role='option'][normalize-space()='25']"
NONPO_INV_ROWS_PER_PAGE_50          = "xpath=//div[@role='option'][normalize-space()='50']"
NONPO_INV_TABLE_ROWS                = "xpath=//table//tbody//tr"
NONPO_INV_SHOWING_TEXT              = "xpath=//p[contains(.,'Showing')]"
NONPO_INV_NEXT_PAGE_BTN             = "xpath=//a[@aria-label='Go to next page']"
NONPO_INV_PREV_PAGE_BTN             = "xpath=//a[@aria-label='Go to previous page']"
NONPO_INV_NO_DATA_MESSAGE           = "xpath=//*[contains(normalize-space(.),'No') and contains(normalize-space(.),'found')]"

# ── STATUS FILTER ON INVOICES TAB ──────────────────────────────────────
# The "Status" combobox (multi-select with search in the Invoices tab)
NONPO_INV_STATUS_DROPDOWN           = "xpath=//div[label[contains(normalize-space(),'Status')]]//button[@type='button'] | //button[@aria-haspopup='dialog'][contains(.,'None') or contains(.,'Selected')]"
# "Ready for Review" filter option  (visible in the open dropdown list)
NONPO_INV_STATUS_READY_FOR_REVIEW   = "xpath=//div[@data-state='open']//div[@role='option'][normalize-space()='Finance Review Pending'] | //div[@data-state='open']//div[@role='option'][contains(normalize-space(),'Ready for Review')]"

# ── PAYMENT REQUESTS TABLE ─────────────────────────────────────────────
# Any PR number link in the Payment Requests tab (first column, clickable span)
NONPO_PR_NUMBER_LINKS               = "xpath=//table//tbody//tr//td[contains(@class,'pr') or position()=2]//span[contains(@class,'cursor-pointer') or @role='link'] | //table//tbody//tr//td[2]//a | //table//tbody//tr//td[2]"

# ── EYE ICON IN INVOICES TAB ──────────────────────────────────────────
# Eye icon buttons in the invoices tab (per row in table)
NONPO_INV_EYE_ICON                  = "xpath=//table//tbody//tr[1]//button[@title='View invoice' or contains(@class,'eye') or @data-slot='icon-button'] | //table//tbody//tr[1]/td[1]//button | //table//tbody//tr[1]//button[1]"

# ── INVOICE DETAIL PAGE ────────────────────────────────────────────────
# "Start finance review" button inside the invoice detail / side-panel
NONPO_INV_START_FINANCE_REVIEW_BTN  = "xpath=//button[normalize-space()='Start Finance Review'] | //button[contains(normalize-space(),'Start') and contains(normalize-space(),'Finance') and contains(normalize-space(),'Review')]"
