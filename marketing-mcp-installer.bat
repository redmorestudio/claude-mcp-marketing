@echo off
echo =======================================================
echo Marketing MCP Servers - One-Click Installer
echo =======================================================
echo.
echo This script will automatically install the most useful
echo MCP servers for marketing professionals using Claude.
echo.
echo Please wait while we set everything up...
echo.

:: Check for Node.js installation
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Node.js is not installed. Installing Node.js...
    echo Please follow the installation prompts when they appear.
    echo After Node.js installation, please run this script again.
    start https://nodejs.org/dist/v18.18.2/node-v18.18.2-x64.msi
    pause
    exit
)

:: Check npm version
echo Checking npm version...
npm --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: npm is not installed properly.
    echo Please install Node.js from https://nodejs.org/
    pause
    exit
)

echo Node.js is installed. Installing essential marketing MCP servers...

:: Create Claude Desktop config directory if it doesn't exist
if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"

:: Get the current user's document folder path
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do set DOCUMENTS=%%b
:: Get the current user's desktop folder path
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do set DESKTOP=%%b

:: Create the Claude Desktop config file
echo Creating Claude Desktop configuration with marketing MCP servers...
(
echo {
echo   "mcpServers": {
echo     "brave-search": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-brave-search"
echo       ]
echo     },
echo     "filesystem": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-filesystem",
echo         "%DOCUMENTS:\=\\%",
echo         "%DESKTOP:\=\\%"
echo       ]
echo     },
echo     "memory": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-memory"
echo       ]
echo     },
echo     "puppeteer": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-puppeteer"
echo       ]
echo     },
echo     "slack": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-slack"
echo       ]
echo     },
echo     "bluesky": {
echo       "command": "npx",
echo       "args": [
echo         "-y",
echo         "@modelcontextprotocol/server-bluesky"
echo       ]
echo     }
echo   }
echo }
) > "%APPDATA%\Claude\claude_desktop_config.json"

echo.
echo Installation complete! Here's what's been installed:
echo 1. Brave Search - For market research and trend analysis
echo 2. File System - For accessing and organizing marketing documents
echo 3. Memory - For saving important information between conversations
echo 4. Puppeteer - For automating web browsing and collecting content
echo 5. Slack - For team communication and workflow automation
echo 6. Bluesky - For social media content creation and engagement
echo.
echo Now you need to:
echo 1. Close Claude Desktop if it's running
echo 2. Open Claude Desktop again
echo 3. Look for the hammer icon in the bottom right of the text input area
echo.
echo Enjoy using Claude with MCP for your marketing work!
echo.
pause