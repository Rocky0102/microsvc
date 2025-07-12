@echo off
echo Stopping all microservices...
echo.

echo Killing Java processes for microservices...
for /f "tokens=2" %%i in ('tasklist /fi "imagename eq java.exe" /fo table /nh ^| findstr "java.exe"') do (
    echo Stopping process %%i
    taskkill /pid %%i /f >nul 2>&1
)

echo.
echo All microservices stopped.
pause
