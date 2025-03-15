#!/bin/bash

echo "======================================================="
echo "Marketing MCP Servers - Installer"
echo "======================================================="
echo
echo "This script will install the most useful MCP servers"
echo "for marketing professionals using Claude."
echo
echo "Checking prerequisites..."
echo

# Check for Node.js installation
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed."
    echo "Please install Node.js from https://nodejs.org/ (LTS version recommended)"
    echo "After installing, restart this script."
    exit 1
else
    NODE_VERSION=$(node --version)
    echo "✅ Node.js is installed (version: $NODE_VERSION)"
fi

# Check for npm installation
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed or not in PATH."
    echo "Please reinstall Node.js from https://nodejs.org/"
    exit 1
else
    NPM_VERSION=$(npm --version)
    echo "✅ npm is installed (version: $NPM_VERSION)"
fi

# Check for Python installation for Perplexity
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is not installed."
    echo "Python is required for the Perplexity MCP server."
    echo "Please install Python from https://www.python.org/downloads/ (Python 3.10+ recommended)"
    echo "The Perplexity server will be skipped, but other servers will still be installed."
    PYTHON_INSTALLED=false
else
    if command -v python3 &> /dev/null; then
        PYTHON_COMMAND="python3"
    else
        PYTHON_COMMAND="python"
    fi
    PYTHON_VERSION=$($PYTHON_COMMAND --version)
    echo "✅ Python is installed ($PYTHON_VERSION)"
    PYTHON_INSTALLED=true
fi

# Check for pip installation
if $PYTHON_INSTALLED; then
    if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
        echo "❌ pip is not installed or not in PATH."
        echo "pip is required for the Perplexity MCP server."
        echo "The Perplexity server will be skipped, but other servers will still be installed."
        PIP_INSTALLED=false
    else
        if command -v pip3 &> /dev/null; then
            PIP_COMMAND="pip3"
        else
            PIP_COMMAND="pip"
        fi
        PIP_VERSION=$($PIP_COMMAND --version)
        echo "✅ pip is installed"
        PIP_INSTALLED=true
    fi
else
    PIP_INSTALLED=false
fi

echo
echo "Installing essential marketing MCP servers..."
echo

# Create Claude Desktop config directory if it doesn't exist
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    mkdir -p ~/Library/Application\ Support/Claude
    CONFIG_PATH=~/Library/Application\ Support/Claude/claude_desktop_config.json
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    mkdir -p ~/.config/Claude
    CONFIG_PATH=~/.config/Claude/claude_desktop_config.json
else
    # Assuming Windows - This won't run in bash but keeping for completeness
    mkdir -p "$APPDATA/Claude"
    CONFIG_PATH="$APPDATA/Claude/claude_desktop_config.json"
fi

# Check if Claude Desktop config already exists and create backup if needed
if [ -f "$CONFIG_PATH" ]; then
    echo "Existing Claude configuration found. Creating backup..."
    cp "$CONFIG_PATH" "${CONFIG_PATH}.backup"
fi

# Create a basic Claude Desktop config file if it doesn't exist
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Creating new Claude Desktop configuration file..."
    echo "{\"mcpServers\": {}}" > "$CONFIG_PATH"
else
    # Check if the file has valid JSON and has mcpServers object
    if ! jq . "$CONFIG_PATH" &>/dev/null; then
        echo "Warning: Existing configuration file is not valid JSON. Creating a new one..."
        echo "{\"mcpServers\": {}}" > "$CONFIG_PATH"
    elif ! jq '.mcpServers' "$CONFIG_PATH" &>/dev/null; then
        echo "Warning: Configuration file doesn't have mcpServers section. Adding it..."
        TEMP_CONFIG=$(jq '. + {mcpServers: {}}' "$CONFIG_PATH")
        echo "$TEMP_CONFIG" > "$CONFIG_PATH"
    fi
fi

# Install MCP servers using mcp-get
echo "Installing MCP servers using mcp-get..."

# Track installation success/failure
SUCCESSFUL_INSTALLS=()
FAILED_INSTALLS=()

# Install Brave Search
echo
echo "Installing Brave Search MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-brave-search; then
    SUCCESSFUL_INSTALLS+=("Brave Search")
    echo "✅ Brave Search MCP server installed successfully"
else
    FAILED_INSTALLS+=("Brave Search")
    echo "❌ Failed to install Brave Search MCP server"
fi

# Install File System
echo
echo "Installing File System MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-filesystem; then
    SUCCESSFUL_INSTALLS+=("File System")
    echo "✅ File System MCP server installed successfully"
else
    FAILED_INSTALLS+=("File System")
    echo "❌ Failed to install File System MCP server"
fi

# Install Memory
echo
echo "Installing Memory MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-memory; then
    SUCCESSFUL_INSTALLS+=("Memory")
    echo "✅ Memory MCP server installed successfully"
else
    FAILED_INSTALLS+=("Memory")
    echo "❌ Failed to install Memory MCP server"
fi

# Install Puppeteer
echo
echo "Installing Puppeteer MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-puppeteer; then
    SUCCESSFUL_INSTALLS+=("Puppeteer")
    echo "✅ Puppeteer MCP server installed successfully"
else
    FAILED_INSTALLS+=("Puppeteer")
    echo "❌ Failed to install Puppeteer MCP server"
fi

# Install Slack
echo
echo "Installing Slack MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-slack; then
    SUCCESSFUL_INSTALLS+=("Slack")
    echo "✅ Slack MCP server installed successfully"
else
    FAILED_INSTALLS+=("Slack")
    echo "❌ Failed to install Slack MCP server"
fi

# Install Bluesky
echo
echo "Installing Bluesky MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-bluesky; then
    SUCCESSFUL_INSTALLS+=("Bluesky")
    echo "✅ Bluesky MCP server installed successfully"
else
    FAILED_INSTALLS+=("Bluesky")
    echo "❌ Failed to install Bluesky MCP server"
fi

# Install Fetch
echo
echo "Installing Fetch MCP server..."
if npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-fetch; then
    SUCCESSFUL_INSTALLS+=("Fetch")
    echo "✅ Fetch MCP server installed successfully"
else
    FAILED_INSTALLS+=("Fetch")
    echo "❌ Failed to install Fetch MCP server"
fi

# Install Perplexity if Python and pip are available
if $PYTHON_INSTALLED && $PIP_INSTALLED; then
    echo
    echo "Installing Perplexity MCP server..."
    if $PIP_COMMAND install perplexity-mcp; then
        SUCCESSFUL_INSTALLS+=("Perplexity")
        echo "✅ Perplexity MCP server installed successfully"
    else
        FAILED_INSTALLS+=("Perplexity")
        echo "❌ Failed to install Perplexity MCP server"
    fi
else
    echo
    echo "Skipping Perplexity MCP server installation (Python/pip not available)"
    FAILED_INSTALLS+=("Perplexity (missing Python/pip)")
fi

echo
echo "======================================================="
echo "Configuration - API Keys"
echo "======================================================="
echo
echo "Some MCP servers require API keys to function properly."
echo "Let's set them up now so you don't have to edit config files manually."
echo

# Function to open a URL in the default browser
open_url() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$1"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open "$1" &>/dev/null
    else
        echo "Please visit: $1"
    fi
}

# Helper function to update config file with a key
update_config_with_key() {
    local server_name=$1
    local env_var_name=$2
    local key_value=$3
    
    # Check if the server section exists
    if jq ".mcpServers.\"$server_name\"" "$CONFIG_PATH" | grep -q "null"; then
        # Server section doesn't exist, create it
        jq ".mcpServers += {\"$server_name\": {}}" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp" && mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
    fi
    
    # Check if env section exists
    if jq ".mcpServers.\"$server_name\".env" "$CONFIG_PATH" | grep -q "null"; then
        # Env section doesn't exist, create it
        jq ".mcpServers.\"$server_name\" += {\"env\": {}}" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp" && mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
    fi
    
    # Update the key
    jq ".mcpServers.\"$server_name\".env += {\"$env_var_name\": \"$key_value\"}" "$CONFIG_PATH" > "${CONFIG_PATH}.tmp" && mv "${CONFIG_PATH}.tmp" "$CONFIG_PATH"
    
    echo "✅ Updated configuration for $server_name"
}

# Handle Brave Search API Key
if [[ " ${SUCCESSFUL_INSTALLS[@]} " =~ " Brave Search " ]]; then
    echo
    echo "Brave Search requires an API key to function."
    echo "Do you already have a Brave Search API key? (y/n)"
    read -r has_brave_key
    
    if [[ "$has_brave_key" == "y" || "$has_brave_key" == "Y" ]]; then
        echo "Please enter your Brave Search API key:"
        read -r brave_api_key
        update_config_with_key "brave-search" "BRAVE_SEARCH_API_KEY" "$brave_api_key"
    else
        echo "Would you like to get a Brave Search API key now? (y/n)"
        read -r get_brave_key
        if [[ "$get_brave_key" == "y" || "$get_brave_key" == "Y" ]]; then
            echo "Opening Brave Search API website..."
            open_url "https://brave.com/search/api/"
            echo "After you get your API key, you can run this script again to configure it."
        else
            echo "⚠️ Brave Search will be installed but won't work without an API key."
            echo "You can run this script again later to add your API key."
        fi
    fi
fi

# Handle Perplexity API Key
if [[ " ${SUCCESSFUL_INSTALLS[@]} " =~ " Perplexity " ]]; then
    echo
    echo "Perplexity requires an API key to function."
    echo "Do you already have a Perplexity API key? (y/n)"
    read -r has_perplexity_key
    
    if [[ "$has_perplexity_key" == "y" || "$has_perplexity_key" == "Y" ]]; then
        echo "Please enter your Perplexity API key:"
        read -r perplexity_api_key
        update_config_with_key "perplexity-mcp" "PERPLEXITY_API_KEY" "$perplexity_api_key"
        
        echo "Which Perplexity model would you like to use? (default: sonar)"
        echo "Options: sonar, sonar-pro, sonar-deep-research, sonar-reasoning, sonar-reasoning-pro"
        read -r perplexity_model
        if [[ -n "$perplexity_model" ]]; then
            update_config_with_key "perplexity-mcp" "PERPLEXITY_MODEL" "$perplexity_model"
        else
            update_config_with_key "perplexity-mcp" "PERPLEXITY_MODEL" "sonar"
        fi
    else
        echo "Would you like to get a Perplexity API key now? (y/n)"
        read -r get_perplexity_key
        if [[ "$get_perplexity_key" == "y" || "$get_perplexity_key" == "Y" ]]; then
            echo "Opening Perplexity website..."
            open_url "https://perplexity.ai/"
            echo "After you get your API key, you can run this script again to configure it."
        else
            echo "⚠️ Perplexity will be installed but won't work without an API key."
            echo "You can run this script again later to add your API key."
        fi
    fi
fi

# Handle Slack Bot Token
if [[ " ${SUCCESSFUL_INSTALLS[@]} " =~ " Slack " ]]; then
    echo
    echo "Slack requires a Bot Token to function."
    echo "Do you already have a Slack Bot Token? (y/n)"
    read -r has_slack_token
    
    if [[ "$has_slack_token" == "y" || "$has_slack_token" == "Y" ]]; then
        echo "Please enter your Slack Bot Token (starts with xoxb-):"
        read -r slack_bot_token
        update_config_with_key "slack" "SLACK_BOT_TOKEN" "$slack_bot_token"
    else
        echo "Would you like to set up a Slack app to get a Bot Token now? (y/n)"
        read -r get_slack_token
        if [[ "$get_slack_token" == "y" || "$get_slack_token" == "Y" ]]; then
            echo "Opening Slack API website..."
            open_url "https://api.slack.com/apps"
            echo "After you get your Slack Bot Token, you can run this script again to configure it."
        else
            echo "⚠️ Slack will be installed but won't work without a Bot Token."
            echo "You can run this script again later to add your token."
        fi
    fi
fi

# Handle Bluesky App Password
if [[ " ${SUCCESSFUL_INSTALLS[@]} " =~ " Bluesky " ]]; then
    echo
    echo "Bluesky requires your username and app password to function."
    echo "Do you already have a Bluesky account and app password? (y/n)"
    read -r has_bluesky_creds
    
    if [[ "$has_bluesky_creds" == "y" || "$has_bluesky_creds" == "Y" ]]; then
        echo "Please enter your Bluesky username:"
        read -r bluesky_username
        echo "Please enter your Bluesky app password:"
        read -r bluesky_app_password
        update_config_with_key "bluesky" "BLUESKY_USERNAME" "$bluesky_username"
        update_config_with_key "bluesky" "BLUESKY_APP_PASSWORD" "$bluesky_app_password"
    else
        echo "Would you like to set up a Bluesky account and app password now? (y/n)"
        read -r get_bluesky_creds
        if [[ "$get_bluesky_creds" == "y" || "$get_bluesky_creds" == "Y" ]]; then
            echo "Opening Bluesky website..."
            open_url "https://bsky.app/"
            echo "After creating your account, go to Settings > Privacy and Security > App Passwords"
            echo "After you get your app password, you can run this script again to configure it."
        else
            echo "⚠️ Bluesky will be installed but won't work without credentials."
            echo "You can run this script again later to add your credentials."
        fi
    fi
fi

echo
echo "======================================================="
echo "Installation Summary"
echo "======================================================="
echo

if [ ${#SUCCESSFUL_INSTALLS[@]} -gt 0 ]; then
    echo "✅ Successfully installed MCP servers:"
    for server in "${SUCCESSFUL_INSTALLS[@]}"; do
        echo "  - $server"
    done
    echo
fi

if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    echo "❌ Failed to install these MCP servers:"
    for server in "${FAILED_INSTALLS[@]}"; do
        echo "  - $server"
    done
    echo
    echo "You can try installing them manually later or run this script again."
    echo
fi

echo "Next Steps:"
echo "1. Close Claude Desktop if it's running"
echo "2. Open Claude Desktop again"
echo "3. Look for the hammer icon in the bottom right of the text input area"
echo
echo "If you need to add API keys later, just run this script again."
echo "Your installed servers will remain untouched."
echo

read -p "Press Enter to exit..."