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

:: Create a basic Claude Desktop config file
echo Creating Claude Desktop configuration file...
(
echo {
echo   "mcpServers": {}
echo }
) > "%APPDATA%\Claude\claude_desktop_config.json"

:: Install MCP servers using mcp-get
echo Installing MCP servers using mcp-get...

:: Install Brave Search
echo Installing Brave Search MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-brave-search

:: Install File System
echo Installing File System MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-filesystem

:: Install Memory
echo Installing Memory MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-memory

:: Install Puppeteer
echo Installing Puppeteer MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-puppeteer

:: Install Slack
echo Installing Slack MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-slack

:: Install Bluesky
echo Installing Bluesky MCP server...
call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-bluesky

:: Install Perplexity
echo Installing Perplexity MCP server...
:: Check if Python is installed for Perplexity
python --version >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pip install perplexity-mcp
) else (
    echo Warning: Python not found. Skipping Perplexity MCP server installation.
    echo Please install Python from https://www.python.org/downloads/ to use Perplexity.
)

echo.
echo Installation complete! Here's what's been installed:
echo 1. Brave Search - For market research and trend analysis
echo    Requires API key from: https://brave.com/search/api/
echo.
echo 2. File System - For accessing and organizing marketing documents
echo    No API key required
echo.
echo 3. Memory - For saving important information between conversations
echo    No API key required
echo.
echo 4. Puppeteer - For automating web browsing and collecting content
echo    No API key required
echo.
echo 5. Slack - For team communication and workflow automation
echo    Requires Slack Bot Token from: https://api.slack.com/apps
echo.
echo 6. Bluesky - For social media content creation and engagement
echo    Requires App Password from: Bluesky's Settings ^> Privacy and Security ^> App Passwords
echo.
echo 7. Perplexity - For advanced web search and research capabilities
echo    Requires API key from: https://perplexity.ai/
echo.
echo IMPORTANT: For services requiring API keys, you'll need to configure them.
echo To do this, edit your Claude Desktop configuration file at:
echo %APPDATA%\Claude\claude_desktop_config.json
echo.
echo Example configuration for API keys:
echo   "brave-search": {
echo     "env": {
echo       "BRAVE_SEARCH_API_KEY": "YOUR_API_KEY_HERE"
echo     }
echo   },
echo   "perplexity-mcp": {
echo     "env": {
echo       "PERPLEXITY_API_KEY": "YOUR_API_KEY_HERE"
echo     }
echo   }
echo.
echo Now you need to:
echo 1. Close Claude Desktop if it's running
echo 2. Ensure you've added API keys to the configuration file
echo 3. Open Claude Desktop again
echo 4. Look for the hammer icon in the bottom right of the text input area
echo.
echo Enjoy using Claude with MCP for your marketing work!
echo.

pause