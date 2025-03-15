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

:: Check if configuration file exists, create if not
if not exist "%APPDATA%\Claude\claude_desktop_config.json" (
    echo Creating new Claude Desktop configuration file...
    (
    echo {
    echo   "mcpServers": {}
    echo }
    ) > "%APPDATA%\Claude\claude_desktop_config.json"
)

:: Initialize tracking variables
set "SUCCESSFUL_INSTALLS="
set "FAILED_INSTALLS="

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
echo Configuration - API Keys
echo =======================================================
echo.
echo Some MCP servers require API keys to function properly.
echo Let's set them up now so you don't have to edit config files manually.
echo.

:: Install Node.js json tool for editing the config file
echo Installing tools to update configuration...
call npm install -g json >nul 2>nul

:: Update Claude Desktop config with provided API keys
:: This function takes 3 parameters: server name, env var name, and the key value
:update_config
setlocal enabledelayedexpansion
set config_path=%APPDATA%\Claude\claude_desktop_config.json
set temp_config=%TEMP%\claude_config_temp.json

:: Create config if it doesn't exist
if not exist "%config_path%" (
  echo { "mcpServers": {} } > "%config_path%"
)

:: Use node to update the config
node -e "const fs=require('fs'); const path='%config_path%'; const server='%~1'; const env_var='%~2'; const value='%~3'; let config=JSON.parse(fs.readFileSync(path)); config.mcpServers = config.mcpServers || {}; config.mcpServers[server] = config.mcpServers[server] || {}; config.mcpServers[server].env = config.mcpServers[server].env || {}; config.mcpServers[server].env[env_var] = value; fs.writeFileSync(path, JSON.stringify(config, null, 2));"

echo √ Updated configuration for %~1
goto :eof

:: Check if Brave Search was installed
echo %SUCCESSFUL_INSTALLS% | findstr /C:"Brave-Search" >nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Brave Search requires an API key to function.
    set /p has_brave_key="Do you already have a Brave Search API key? (y/n): "
    
    if /i "%has_brave_key%"=="y" (
        set /p brave_api_key="Please enter your Brave Search API key: "
        call :update_config "brave-search" "BRAVE_SEARCH_API_KEY" "%brave_api_key%"
    ) else (
        set /p get_brave_key="Would you like to get a Brave Search API key now? (y/n): "
        if /i "%get_brave_key%"=="y" (
            echo Opening Brave Search API website...
            start https://brave.com/search/api/
            echo After you get your API key, you can run this script again to configure it.
        ) else (
            echo ⚠️ Brave Search will be installed but won't work without an API key.
            echo You can run this script again later to add your API key.
        )
    )
)

:: Check if Perplexity was installed
echo %SUCCESSFUL_INSTALLS% | findstr /C:"Perplexity" >nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Perplexity requires an API key to function.
    set /p has_perplexity_key="Do you already have a Perplexity API key? (y/n): "
    
    if /i "%has_perplexity_key%"=="y" (
        set /p perplexity_api_key="Please enter your Perplexity API key: "
        call :update_config "perplexity-mcp" "PERPLEXITY_API_KEY" "%perplexity_api_key%"
        
        echo Options: sonar, sonar-pro, sonar-deep-research, sonar-reasoning, sonar-reasoning-pro
        set /p perplexity_model="Which Perplexity model would you like to use? (default: sonar): "
        
        if not "%perplexity_model%"=="" (
            call :update_config "perplexity-mcp" "PERPLEXITY_MODEL" "%perplexity_model%"
        ) else (
            call :update_config "perplexity-mcp" "PERPLEXITY_MODEL" "sonar"
        )
    ) else (
        set /p get_perplexity_key="Would you like to get a Perplexity API key now? (y/n): "
        if /i "%get_perplexity_key%"=="y" (
            echo Opening Perplexity website...
            start https://perplexity.ai/
            echo After you get your API key, you can run this script again to configure it.
        ) else (
            echo ⚠️ Perplexity will be installed but won't work without an API key.
            echo You can run this script again later to add your API key.
        )
    )
)

:: Check if Slack was installed
echo %SUCCESSFUL_INSTALLS% | findstr /C:"Slack" >nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Slack requires a Bot Token to function.
    set /p has_slack_token="Do you already have a Slack Bot Token? (y/n): "
    
    if /i "%has_slack_token%"=="y" (
        set /p slack_bot_token="Please enter your Slack Bot Token (starts with xoxb-): "
        call :update_config "slack" "SLACK_BOT_TOKEN" "%slack_bot_token%"
    ) else (
        set /p get_slack_token="Would you like to set up a Slack app to get a Bot Token now? (y/n): "
        if /i "%get_slack_token%"=="y" (
            echo Opening Slack API website...
            start https://api.slack.com/apps
            echo After you get your Slack Bot Token, you can run this script again to configure it.
        ) else (
            echo ⚠️ Slack will be installed but won't work without a Bot Token.
            echo You can run this script again later to add your token.
        )
    )
)

:: Check if Bluesky was installed
echo %SUCCESSFUL_INSTALLS% | findstr /C:"Bluesky" >nul
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Bluesky requires your username and app password to function.
    set /p has_bluesky_creds="Do you already have a Bluesky account and app password? (y/n): "
    
    if /i "%has_bluesky_creds%"=="y" (
        set /p bluesky_username="Please enter your Bluesky username: "
        set /p bluesky_app_password="Please enter your Bluesky app password: "
        call :update_config "bluesky" "BLUESKY_USERNAME" "%bluesky_username%"
        call :update_config "bluesky" "BLUESKY_APP_PASSWORD" "%bluesky_app_password%"
    ) else (
        set /p get_bluesky_creds="Would you like to set up a Bluesky account and app password now? (y/n): "
        if /i "%get_bluesky_creds%"=="y" (
            echo Opening Bluesky website...
            start https://bsky.app/
            echo After creating your account, go to Settings ^> Privacy and Security ^> App Passwords
            echo After you get your app password, you can run this script again to configure it.
        ) else (
            echo ⚠️ Bluesky will be installed but won't work without credentials.
            echo You can run this script again later to add your credentials.
        )
    )
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

echo Next Steps:
echo 1. Close Claude Desktop if it's running
echo 2. Open Claude Desktop again
echo 3. Look for the hammer icon in the bottom right of the text input area
echo.
echo If you need to add API keys later, just run this script again.
echo Your installed servers will remain untouched.
echo.

pause