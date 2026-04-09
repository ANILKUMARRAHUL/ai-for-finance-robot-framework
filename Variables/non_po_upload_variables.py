# =========================
# NON-PO UPLOADS
# =========================
import os
import random

_BASE     = os.path.dirname(os.path.abspath(__file__))
_INV_DIR  = os.path.abspath(os.path.join(_BASE, '..', 'TestData', 'invoice_split'))
_PR_DIR   = os.path.abspath(os.path.join(_BASE, '..', 'TestData', 'pr'))

def _get_number_prefix(filename):
    return filename.split('.')[0] if filename.split('.')[0].isdigit() else None

def _pick_random_invoice_set():
    entries = os.listdir(_INV_DIR)

    # Separate folders (multi-invoice) and single pdf files
    folders   = [e for e in entries if os.path.isdir(os.path.join(_INV_DIR, e)) and e.isdigit()]
    pdf_files = [e for e in entries if e.endswith('.pdf') and _get_number_prefix(e) is not None]

    # Build a pool: each entry is (number_str, [full_paths])
    pool = []

    for folder in folders:
        folder_path = os.path.join(_INV_DIR, folder)
        pdfs = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.endswith('.pdf')]
        if pdfs:
            pool.append((folder, pdfs))

    for pdf in pdf_files:
        num = _get_number_prefix(pdf)
        pool.append((num, [os.path.join(_INV_DIR, pdf)]))

    chosen_num, invoice_paths = random.choice(pool)

    # Find matching PR pdf
    pr_entries = os.listdir(_PR_DIR)
    pr_match   = next(
        (os.path.join(_PR_DIR, f) for f in pr_entries
         if f.endswith('.pdf') and _get_number_prefix(f) == chosen_num),
        None
    )

    return chosen_num, invoice_paths, pr_match

CHOSEN_NUM, INVOICE_PDF_PATHS, PR_PDF_PATH = _pick_random_invoice_set()

# =========================
# UPLOADS PAGE LOCATORS
# =========================
NONPO_UPLOADS_TAB_INVOICE   = "xpath=//button[@role='tab'][normalize-space()='Invoices']"
NONPO_UPLOADS_TAB_PR        = "xpath=//button[@role='tab' and normalize-space()='Payment Request']"
NONPO_ACTIVE_TAB_FILE_INPUT = "xpath=//div[@role='tabpanel' and not(@hidden)]//input[@type='file']"
NONPO_FILE_INPUT            = "xpath=//input[@type='file']"

NONPO_AGREEMENT_DROPDOWN    = "xpath=//input[@placeholder='Select agreement type']"
NONPO_AGREEMENT_OPTIONS     = "xpath=//div[@role='option']"

NONPO_REVIEWER_DROPDOWN     = "xpath=//button[@role='combobox'][@aria-required='true']"
NONPO_REVIEWER_LISTBOX      = "xpath=//div[@role='listbox' and @data-state='open']"
NONPO_REVIEWER_OPTIONS      = "xpath=//div[@role='listbox' and @data-state='open']//div[@role='option']"

NONPO_UPLOAD_DOCUMENTS_BTN  = "xpath=//button[normalize-space()='Upload Documents']"
NONPO_CANCEL_BTN            = "xpath=//button[normalize-space()='Cancel']"

# Incomplete upload dialog
NONPO_INCOMPLETE_DIALOG     = "xpath=//div[@role='alertdialog']"
NONPO_INCOMPLETE_GO_BACK    = "xpath=//button[normalize-space()='Go Back']"
NONPO_INCOMPLETE_CONTINUE   = "xpath=//button[normalize-space()='Continue Anyway']"

# Success toast
NONPO_SUCCESS_TOAST         = "xpath=//li[contains(@class,'cn-toast') and @data-type='success']"