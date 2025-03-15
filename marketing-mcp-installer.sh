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
    # Check if the file has valid JSON
    if ! jq . "$CONFIG_PATH" &>/dev/null; then
        echo "Warning: Existing configuration file is not valid JSON. Creating a new one..."
        echo "{\"mcpServers\": {}}" > "$CONFIG_PATH"
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

echo "API Key Requirements:"
echo "-----------------------------------------------------"
echo "1. Brave Search - Requires API key from: https://brave.com/search/api/"
echo "2. Slack - Requires Slack Bot Token from: https://api.slack.com/apps"
echo "3. Bluesky - Requires App Password from Bluesky settings"
echo "4. Perplexity - Requires API key from: https://perplexity.ai/"
echo
echo "To configure your API keys, edit your Claude Desktop configuration file at:"
echo "$CONFIG_PATH"
echo
echo "Example configuration for API keys:"
echo '  "brave-search": {'
echo '    "env": {'
echo '      "BRAVE_SEARCH_API_KEY": "YOUR_API_KEY_HERE"'
echo '    }'
echo '  },'
echo
echo "Next Steps:"
echo "1. Close Claude Desktop if it's running"
echo "2. Add API keys to the configuration file (see README for details)"
echo "3. Open Claude Desktop again"
echo "4. Look for the hammer icon in the bottom right of the text input area"
echo
echo "For detailed instructions, see the README.md file."
echo

read -p "Press Enter to exit..."