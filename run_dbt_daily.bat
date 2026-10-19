@echo off

REM Kích hoạt virtualenv
call "C:\dbt-projects\amazon_analytics\.venv\Scripts\activate.bat"

REM Vào thư mục project dbt
cd /d "C:\dbt-projects\amazon_analytics\amazon_analytics"

REM Chạy pipeline
dbt deps
dbt seed
dbt run
@REM  dbt test

REM Ghi log
echo %date% %time% - EXIT=%errorlevel% >> "C:\dbt-projects\amazon_analytics\pipeline_log.txt"

exit /b %errorlevel%