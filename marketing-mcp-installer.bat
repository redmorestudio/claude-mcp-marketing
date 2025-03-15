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

:: Install MCP servers using mcp-get
echo Installing MCP servers using mcp-get...

:: Install Brave Search
echo.
echo Installing Brave Search MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-brave-search
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Brave-Search
    echo √ Brave Search MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Brave-Search
    echo X Failed to install Brave Search MCP server
)

:: Install File System
echo.
echo Installing File System MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-filesystem
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% File-System
    echo √ File System MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% File-System
    echo X Failed to install File System MCP server
)

:: Install Memory
echo.
echo Installing Memory MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-memory
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Memory
    echo √ Memory MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Memory
    echo X Failed to install Memory MCP server
)

:: Install Puppeteer
echo.
echo Installing Puppeteer MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-puppeteer
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Puppeteer
    echo √ Puppeteer MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Puppeteer
    echo X Failed to install Puppeteer MCP server
)

:: Install Slack
echo.
echo Installing Slack MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-slack
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Slack
    echo √ Slack MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Slack
    echo X Failed to install Slack MCP server
)

:: Install Bluesky
echo.
echo Installing Bluesky MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-bluesky
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Bluesky
    echo √ Bluesky MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Bluesky
    echo X Failed to install Bluesky MCP server
)

:: Install Fetch
echo.
echo Installing Fetch MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-fetch
if %ERRORLEVEL% EQU 0 (
    set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Fetch
    echo √ Fetch MCP server installed successfully
) else (
    set FAILED_INSTALLS=%FAILED_INSTALLS% Fetch
    echo X Failed to install Fetch MCP server
)

:: Install Perplexity if Python and pip are available
if "%PYTHON_INSTALLED%"=="true" if "%PIP_INSTALLED%"=="true" (
    echo.
    echo Installing Perplexity MCP server...
    pip install perplexity-mcp
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Perplexity
        echo √ Perplexity MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Perplexity
        echo X Failed to install Perplexity MCP server
    )
) else (
    echo.
    echo Skipping Perplexity MCP server installation (Python/pip not available)
    set FAILED_INSTALLS=%FAILED_INSTALLS% Perplexity(missing-Python)
)

echo.
echo =======================================================
echo Installation Summary
echo =======================================================
echo.

echo Installed MCP servers: %SUCCESSFUL_INSTALLS%
echo.

if NOT "%FAILED_INSTALLS%"=="" (
    echo Failed installations: %FAILED_INSTALLS%
    echo You can try installing them manually later or run this script again.
    echo.
)

echo API Key Requirements:
echo -----------------------------------------------------
echo 1. Brave Search - Requires API key from: https://brave.com/search/api/
echo 2. Slack - Requires Slack Bot Token from: https://api.slack.com/apps
echo 3. Bluesky - Requires App Password from Bluesky settings
echo 4. Perplexity - Requires API key from: https://perplexity.ai/
echo.
echo To configure your API keys, edit your Claude Desktop configuration file at:
echo %APPDATA%\Claude\claude_desktop_config.json
echo.
echo Example configuration for API keys:
echo   "brave-search": {
echo     "env": {
echo       "BRAVE_SEARCH_API_KEY": "YOUR_API_KEY_HERE"
echo     }
echo   },
echo.
echo Next Steps:
echo 1. Close Claude Desktop if it's running
echo 2. Add API keys to the configuration file (see README for details)
echo 3. Open Claude Desktop again
echo 4. Look for the hammer icon in the bottom right of the text input area
echo.
echo For detailed instructions, see the README.md file.
echo.

pause