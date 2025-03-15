#!/bin/bash

echo "======================================================="
echo "Marketing MCP Servers - One-Click Installer"
echo "======================================================="
echo
echo "This script will automatically install the most useful"
echo "MCP servers for marketing professionals using Claude."
echo
echo "Please wait while we set everything up..."
echo

# Check for Node.js installation
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed."
    echo "Installing Node.js..."
    
    # Check if macOS or Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - try to use brew if available
        if command -v brew &> /dev/null; then
            brew install node
        else
            echo "Please install Homebrew first with this command:"
            echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
            echo "Then run this script again."
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y nodejs npm
        # Fedora/RHEL/CentOS
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y nodejs npm
        else
            echo "Could not automatically install Node.js."
            echo "Please install Node.js from https://nodejs.org/"
            exit 1
        fi
    else
        echo "Unsupported operating system for automatic Node.js installation."
        echo "Please install Node.js from https://nodejs.org/"
        exit 1
    fi
fi

# Verify Node.js installation
if ! command -v node &> /dev/null; then
    echo "Node.js installation failed. Please install it manually from https://nodejs.org/"
    exit 1
else
    echo "Node.js is installed successfully."
fi

# Check npm version
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed properly."
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "Installing essential marketing MCP servers..."

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

# Create the Claude Desktop config file with 7 useful marketing MCP servers
echo "Creating Claude Desktop configuration with marketing MCP servers..."

# Get Document and Desktop paths for file system server
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DOCUMENTS_PATH="$HOME/Documents"
    DESKTOP_PATH="$HOME/Desktop"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    DOCUMENTS_PATH="$HOME/Documents"
    DESKTOP_PATH="$HOME/Desktop"
else
    # Windows (not applicable in bash, but for documentation)
    DOCUMENTS_PATH="%USERPROFILE%\\Documents"
    DESKTOP_PATH="%USERPROFILE%\\Desktop"
fi

# Generate a template for the configuration file
cat > "$CONFIG_PATH" << EOL
{
  "mcpServers": {}
}
EOL

# Install MCP servers using mcp-get
echo "Installing MCP servers using mcp-get..."

# Install Brave Search
echo "Installing Brave Search MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-brave-search

# Install File System
echo "Installing File System MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-filesystem

# Install Memory
echo "Installing Memory MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-memory

# Install Puppeteer
echo "Installing Puppeteer MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-puppeteer

# Install Slack
echo "Installing Slack MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-slack

# Install Bluesky
echo "Installing Bluesky MCP server..."
npx -y @michaellatman/mcp-get@latest install @modelcontextprotocol/server-bluesky

# Install Perplexity
echo "Installing Perplexity MCP server..."
# Using Perpelexity with uv package manager if available
if command -v uv &> /dev/null; then
    uv pip install perplexity-mcp
else
    if command -v pip &> /dev/null; then
        pip install perplexity-mcp
    else
        echo "Warning: Could not install Perplexity MCP server. Please install pip or uv first."
    fi
fi

echo
echo "Installation complete! Here's what's been installed:"
echo "1. Brave Search - For market research and trend analysis"
echo "   Requires API key from: https://brave.com/search/api/"
echo
echo "2. File System - For accessing and organizing marketing documents"
echo "   No API key required"
echo
echo "3. Memory - For saving important information between conversations"
echo "   No API key required"
echo
echo "4. Puppeteer - For automating web browsing and collecting content"
echo "   No API key required"
echo
echo "5. Slack - For team communication and workflow automation"
echo "   Requires Slack Bot Token from: https://api.slack.com/apps"
echo
echo "6. Bluesky - For social media content creation and engagement"
echo "   Requires App Password from: Bluesky's Settings > Privacy and Security > App Passwords"
echo
echo "7. Perplexity - For advanced web search and research capabilities"
echo "   Requires API key from: https://perplexity.ai/"
echo
echo "IMPORTANT: For services requiring API keys, you'll need to configure them."
echo "To do this, edit your Claude Desktop configuration file at:"
echo "$CONFIG_PATH"
echo
echo "Example configuration for API keys:"
echo '  "brave-search": {'
echo '    "env": {'
echo '      "BRAVE_SEARCH_API_KEY": "YOUR_API_KEY_HERE"'
echo '    }'
echo '  },'
echo '  "perplexity-mcp": {'
echo '    "env": {'
echo '      "PERPLEXITY_API_KEY": "YOUR_API_KEY_HERE"'
echo '    }'
echo '  }'
echo
echo "Now you need to:"
echo "1. Close Claude Desktop if it's running"
echo "2. Ensure you've added API keys to the configuration file"
echo "3. Open Claude Desktop again"
echo "4. Look for the hammer icon in the bottom right of the text input area"
echo
echo "Enjoy using Claude with MCP for your marketing work!"
echo

read -p "Press Enter to exit..."