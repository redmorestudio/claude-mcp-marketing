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
echo Checking for installed MCP servers...
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

:: Install Node.js json tool for checking the config
call npm install -g json >nul 2>nul

:: Initialize tracking variables
set "EXISTING_INSTALLS="
set "SUCCESSFUL_INSTALLS="
set "FAILED_INSTALLS="
set "NEED_API_CONFIG=false"

:: Function to check if server is installed in config
:check_server_installed
    :: Parameters: %1 - server name, %2 - package name
    setlocal
    set "IS_INSTALLED=false"
    
    :: Check global npm packages
    call npm list -g %~2 >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set "IS_INSTALLED=true"
        goto :check_server_end
    )
    
    :: Check if exists in Claude config
    node -e "try { const fs=require('fs'); const config=JSON.parse(fs.readFileSync('%APPDATA%\\Claude\\claude_desktop_config.json')); if(config.mcpServers && config.mcpServers['%~1']) process.exit(0); else process.exit(1); } catch(e) { process.exit(1); }" >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set "IS_INSTALLED=true"
    )
    
    :check_server_end
    endlocal & set "SERVER_INSTALLED=%IS_INSTALLED%"
    exit /b

:: Function to check if env variable is configured
:check_env_configured
    :: Parameters: %1 - server name, %2 - env var name
    setlocal
    
    node -e "try { const fs=require('fs'); const config=JSON.parse(fs.readFileSync('%APPDATA%\\Claude\\claude_desktop_config.json')); if(config.mcpServers && config.mcpServers['%~1'] && config.mcpServers['%~1'].env && config.mcpServers['%~1'].env['%~2']) process.exit(0); else process.exit(1); } catch(e) { process.exit(1); }" >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        endlocal & set "ENV_CONFIGURED=true"
    ) else (
        endlocal & set "ENV_CONFIGURED=false"
    )
    exit /b

:: Update Claude Desktop config with provided API keys
:update_config
    :: Parameters: %1 - server name, %2 - env var name, %3 - key value
    setlocal enabledelayedexpansion
    
    node -e "try { const fs=require('fs'); const path='%APPDATA%\\Claude\\claude_desktop_config.json'; const config=JSON.parse(fs.readFileSync(path)); config.mcpServers = config.mcpServers || {}; config.mcpServers['%~1'] = config.mcpServers['%~1'] || {}; config.mcpServers['%~1'].env = config.mcpServers['%~1'].env || {}; config.mcpServers['%~1'].env['%~2'] = '%~3'; fs.writeFileSync(path, JSON.stringify(config, null, 2)); process.exit(0); } catch(e) { console.error(e); process.exit(1); }" >nul 2>nul
    
    if %ERRORLEVEL% EQU 0 (
        echo √ Updated configuration for %~1
    ) else (
        echo X Failed to update configuration for %~1
    )
    
    endlocal
    exit /b

:: Check brave-search server
call :check_server_installed "brave-search" "@modelcontextprotocol/server-brave-search"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Brave Search MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Brave-Search
) else (
    echo Installing Brave Search MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-brave-search
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Brave-Search
        echo √ Brave Search MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Brave-Search
        echo X Failed to install Brave Search MCP server
    )
)

:: Check filesystem server
call :check_server_installed "filesystem" "@modelcontextprotocol/server-filesystem"
if "%SERVER_INSTALLED%"=="true" (
    echo √ File System MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% File-System
) else (
    echo Installing File System MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-filesystem
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% File-System
        echo √ File System MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% File-System
        echo X Failed to install File System MCP server
    )
)

:: Check memory server
call :check_server_installed "memory" "@modelcontextprotocol/server-memory"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Memory MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Memory
) else (
    echo Installing Memory MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-memory
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Memory
        echo √ Memory MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Memory
        echo X Failed to install Memory MCP server
    )
)

:: Check puppeteer server
call :check_server_installed "puppeteer" "@modelcontextprotocol/server-puppeteer"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Puppeteer MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Puppeteer
) else (
    echo Installing Puppeteer MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-puppeteer
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Puppeteer
        echo √ Puppeteer MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Puppeteer
        echo X Failed to install Puppeteer MCP server
    )
)

:: Check slack server
call :check_server_installed "slack" "@modelcontextprotocol/server-slack"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Slack MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Slack
) else (
    echo Installing Slack MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-slack
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Slack
        echo √ Slack MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Slack
        echo X Failed to install Slack MCP server
    )
)

:: Check bluesky server
call :check_server_installed "bluesky" "@modelcontextprotocol/server-bluesky"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Bluesky MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Bluesky
) else (
    echo Installing Bluesky MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-bluesky
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Bluesky
        echo √ Bluesky MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Bluesky
        echo X Failed to install Bluesky MCP server
    )
)

:: Check fetch server
call :check_server_installed "fetch" "@modelcontextprotocol/server-fetch"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Fetch MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Fetch
) else (
    echo Installing Fetch MCP server...
    call npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-fetch
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Fetch
        echo √ Fetch MCP server installed successfully
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Fetch
        echo X Failed to install Fetch MCP server
    )
)

:: Check perplexity
set "PERPLEXITY_INSTALLED=false"
call :check_server_installed "perplexity-mcp" "perplexity-mcp"
if "%SERVER_INSTALLED%"=="true" (
    echo √ Perplexity MCP server already installed
    set EXISTING_INSTALLS=%EXISTING_INSTALLS% Perplexity
    set "PERPLEXITY_INSTALLED=true"
) else if "%PYTHON_INSTALLED%"=="true" if "%PIP_INSTALLED%"=="true" (
    echo Installing Perplexity MCP server...
    pip install perplexity-mcp
    if %ERRORLEVEL% EQU 0 (
        set SUCCESSFUL_INSTALLS=%SUCCESSFUL_INSTALLS% Perplexity
        echo √ Perplexity MCP server installed successfully
        set "PERPLEXITY_INSTALLED=true"
    ) else (
        set FAILED_INSTALLS=%FAILED_INSTALLS% Perplexity
        echo X Failed to install Perplexity MCP server
    )
) else (
    echo Skipping Perplexity MCP server installation (Python/pip not available)
    set FAILED_INSTALLS=%FAILED_INSTALLS% Perplexity(missing-Python)
)

echo.
echo =======================================================
echo Configuration - API Keys
echo =======================================================
echo.
echo Checking for API keys and credentials...
echo.

:: Check if brave search API key is already configured
set "NEED_API_CONFIG=false"
:: Create a variable with all installed servers
set "ALL_INSTALLED=%EXISTING_INSTALLS% %SUCCESSFUL_INSTALLS%"

:: Check Brave Search API key
echo %ALL_INSTALLED% | findstr /C:"Brave-Search" >nul
if %ERRORLEVEL% EQU 0 (
    call :check_env_configured "brave-search" "BRAVE_SEARCH_API_KEY"
    if "%ENV_CONFIGURED%"=="false" (
        set "NEED_API_CONFIG=true"
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
    ) else (
        echo √ Brave Search API key already configured
    )
)

:: Check Perplexity API key
if "%PERPLEXITY_INSTALLED%"=="true" (
    call :check_env_configured "perplexity-mcp" "PERPLEXITY_API_KEY"
    if "%ENV_CONFIGURED%"=="false" (
        set "NEED_API_CONFIG=true"
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
    ) else (
        echo √ Perplexity API key already configured
    )
)

:: Check Slack Bot Token
echo %ALL_INSTALLED% | findstr /C:"Slack" >nul
if %ERRORLEVEL% EQU 0 (
    call :check_env_configured "slack" "SLACK_BOT_TOKEN"
    if "%ENV_CONFIGURED%"=="false" (
        set "NEED_API_CONFIG=true"
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
    ) else (
        echo √ Slack Bot Token already configured
    )
)

:: Check Bluesky credentials
echo %ALL_INSTALLED% | findstr /C:"Bluesky" >nul
if %ERRORLEVEL% EQU 0 (
    call :check_env_configured "bluesky" "BLUESKY_USERNAME"
    set "USERNAME_CONFIGURED=%ENV_CONFIGURED%"
    call :check_env_configured "bluesky" "BLUESKY_APP_PASSWORD"
    set "PASSWORD_CONFIGURED=%ENV_CONFIGURED%"
    
    if "%USERNAME_CONFIGURED%"=="false" if "%PASSWORD_CONFIGURED%"=="false" (
        set "NEED_API_CONFIG=true"
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
    ) else (
        echo √ Bluesky credentials already configured
    )
)

if "%NEED_API_CONFIG%"=="false" (
    echo ✓ All required API keys and credentials are already configured.
)

echo.
echo =======================================================
echo Installation Summary
echo =======================================================
echo.

if not "%EXISTING_INSTALLS%"=="" (
    echo ✓ Already installed MCP servers: %EXISTING_INSTALLS%
    echo.
)

if not "%SUCCESSFUL_INSTALLS%"=="" (
    echo ✓ Newly installed MCP servers: %SUCCESSFUL_INSTALLS%
    echo.
)

if not "%FAILED_INSTALLS%"=="" (
    echo X Failed installations: %FAILED_INSTALLS%
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