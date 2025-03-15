@echo off
echo =======================================================
echo Marketing MCP Servers - Installer
echo =======================================================
echo.
echo This script will install the most useful MCP servers
echo for marketing professionals using Claude.
echo.
echo Checking prerequisites...
echo.

:: Check for Node.js installation
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X Node.js is not installed.
    echo Please install Node.js from https://nodejs.org/ (LTS version recommended)
    echo After installing, restart this script.
    echo.
    start https://nodejs.org/
    pause
    exit
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo √ Node.js is installed (version: %NODE_VERSION%)
)

:: Check npm version
echo Checking npm version...
npm --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X npm is not installed properly.
    echo Please reinstall Node.js from https://nodejs.org/
    pause
    exit
) else (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo √ npm is installed (version: %NPM_VERSION%)
)

:: Check for Python installation for Perplexity
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X Python is not installed.
    echo Python is required for the Perplexity MCP server.
    echo Please install Python from https://www.python.org/downloads/ (Python 3.10+ recommended)
    echo The Perplexity server will be skipped, but other servers will still be installed.
    set PYTHON_INSTALLED=false
) else (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo √ Python is installed (%PYTHON_VERSION%)
    set PYTHON_INSTALLED=true
)

:: Check for pip installation
if "%PYTHON_INSTALLED%"=="true" (
    where pip >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo X pip is not installed or not in PATH.
        echo pip is required for the Perplexity MCP server.
        echo The Perplexity server will be skipped, but other servers will still be installed.
        set PIP_INSTALLED=false
    ) else (
        echo √ pip is installed
        set PIP_INSTALLED=true
    )
) else (
    set PIP_INSTALLED=false
)

echo.
echo Installing essential marketing MCP servers...
echo.

:: Create Claude Desktop config directory if it doesn't exist
if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"

:: Create a basic Claude Desktop config file if it doesn't exist
if not exist "%APPDATA%\Claude\claude_desktop_config.json" (
    echo Creating new Claude Desktop configuration file...
    (
    echo {
    echo   "mcpServers": {}
    echo }
    ) > "%APPDATA%\Claude\claude_desktop_config.json"
)

:: Initialize tracking variables
set SUCCESSFUL_INSTALLS=
set FAILED_INSTALLS=
