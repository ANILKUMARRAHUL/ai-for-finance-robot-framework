@echo off
cd /d "D:\AI For Finance\Testcases\InvoiceCheck\"
call "D:\AI For Finance\venv\Scripts\activate"
call robot -d "D:\AI For Finance\results" -t "Validate State Wise Data Loading" dashboard_testcases.robot >> "D:\AI For Finance\run_log.txt" 2>&1