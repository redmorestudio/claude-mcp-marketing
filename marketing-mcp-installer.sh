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

# Create the Claude Desktop config file with 6 useful marketing MCP servers
echo "Creating Claude Desktop configuration with marketing MCP servers..."

cat > "$CONFIG_PATH" << EOL
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-brave-search"
      ]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "$HOME/Documents",
        "$HOME/Desktop"
      ]
    },
    "memory": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-memory"
      ]
    },
    "puppeteer": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-puppeteer"
      ]
    },
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ]
    },
    "bluesky": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-bluesky"
      ]
    }
  }
}
EOL

echo
echo "Installation complete! Here's what's been installed:"
echo "1. Brave Search - For market research and trend analysis"
echo "2. File System - For accessing and organizing marketing documents"
echo "3. Memory - For saving important information between conversations"
echo "4. Puppeteer - For automating web browsing and collecting content"
echo "5. Slack - For team communication and workflow automation"
echo "6. Bluesky - For social media content creation and engagement"
echo
echo "Now you need to:"
echo "1. Close Claude Desktop if it's running"
echo "2. Open Claude Desktop again"
echo "3. Look for the hammer icon in the bottom right of the text input area"
echo
echo "Enjoy using Claude with MCP for your marketing work!"
echo

read -p "Press Enter to exit..."