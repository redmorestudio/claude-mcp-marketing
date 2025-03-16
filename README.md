# Claude MCP for Marketing Professionals

A simple installer for the most useful Model Context Protocol (MCP) servers for marketing professionals using Claude.

## What is MCP?

Model Context Protocol (MCP) allows Claude to connect with external tools, websites, and data sources—dramatically expanding what it can do for you. With MCP, Claude can search the web, access your files, remember important information, and much more.

## Prerequisites

Before running the installer, you'll need to have the following installed:

1. **Node.js** (Required for most MCP servers)
   - Download and install from [nodejs.org](https://nodejs.org/) (LTS version recommended)
   - After installation, verify it works by opening a terminal/command prompt and typing `node --version`

2. **Python** (Required for Perplexity integration)
   - Download and install from [python.org/downloads](https://python.org/downloads/) (Python 3.10 or higher)
   - Make sure to check "Add Python to PATH" during installation (Windows)
   - After installation, verify it works by typing `python --version` in a terminal/command prompt

3. **Claude Desktop**
   - Download from [claude.ai/download](https://claude.ai/download) if you haven't already

## What This Installs

This installer configures Claude Desktop with eight essential MCP servers for marketing work:

1. **Brave Search** - For market research and trend analysis
   - Search for the latest industry trends and competitor information
   - Research customer preferences and behavior
   - Find inspiration for campaigns and content
   - **Requires API key:** You'll be prompted to enter it or directed to get one

2. **File System** - For accessing and organizing marketing documents
   - Organize marketing materials and assets
   - Create, edit, and manage documents
   - Analyze performance reports and data
   - **No API key required**

3. **Memory** - For saving important information between conversations
   - Store brand guidelines and messaging frameworks
   - Remember audience insights and personas
   - Keep track of campaign strategies and deadlines
   - **No API key required**

4. **Puppeteer** - For automating web browsing and collecting content
   - Scrape web content for competitive analysis
   - Automate repetitive web tasks
   - Take screenshots of competitor websites or campaigns
   - **No API key required**

5. **Slack** - For team communication and workflow automation
   - Send and receive messages on Slack
   - Create automated workflows with your marketing team
   - Schedule and manage campaign updates
   - **Requires Slack Bot Token:** You'll be prompted to enter it or directed to create one

6. **Bluesky** - For social media content creation and engagement
   - Create and publish Bluesky posts
   - Analyze engagement and community growth
   - Monitor trends and conversations
   - **Requires Bluesky credentials:** You'll be prompted to enter them or directed to create an account

7. **Perplexity** - For advanced web search and research capabilities
   - Perform in-depth research with source citations
   - Get recent information about marketing trends and news
   - Analyze competitor strategies and market positions
   - **Requires API key:** You'll be prompted to enter it or directed to get one

8. **Fetch** - For retrieving web content from specific URLs
   - Access and analyze articles and blog posts
   - Extract content from websites for research
   - Monitor specific pages for changes
   - **No API key required**

## Installation Instructions

### For Windows Users

1. Make sure you've installed Node.js and Python as described in the prerequisites
2. Download the [marketing-mcp-installer.bat](marketing-mcp-installer.bat) file
3. Double-click the file to run it
4. The script will check for the required dependencies and install the MCP servers
5. When prompted, enter any API keys you already have, or choose to get them later
6. Once the installation is complete, restart Claude Desktop
7. Look for the hammer icon in the bottom right of the text input area

### For Mac Users

1. Make sure you've installed Node.js and Python as described in the prerequisites
2. Download the [marketing-mcp-installer.sh](marketing-mcp-installer.sh) file
3. Open Terminal (search for "Terminal" in Spotlight)
4. Type `chmod +x ` (with a space after it)
5. Drag the marketing-mcp-installer.sh file into Terminal and press Enter
6. Now drag the file into Terminal again and press Enter to run it
7. When prompted, enter any API keys you already have, or choose to get them later
8. Once the installation is complete, restart Claude Desktop
9. Look for the hammer icon in the bottom right of the text input area

## Getting API Keys

If you don't already have the necessary API keys, here's how to get them:

1. **Brave Search API Key**: Sign up at [Brave Search API](https://brave.com/search/api/)
   - Create a Brave account if you don't have one
   - Navigate to the API section
   - Register for an API key

2. **Perplexity API Key**: Create an account at [Perplexity AI](https://perplexity.ai/)
   - Sign up for an account
   - Go to your account settings
   - Generate an API key

3. **Slack Bot Token**: 
   - Go to [Slack API Apps](https://api.slack.com/apps)
   - Create a new app
   - Add necessary bot token scopes under "OAuth & Permissions"
   - Install the app to your workspace
   - Copy the Bot User OAuth Token (starts with "xoxb-")

4. **Bluesky App Password**:
   - Create an account at [Bluesky](https://bsky.app/)
   - Go to Settings > Privacy and Security > App Passwords
   - Create a new app password

## Troubleshooting

If you encounter issues during installation:

1. **Node.js not found**: Make sure Node.js is properly installed and in your PATH
2. **Python not found**: Ensure Python is installed and in your PATH
3. **Server not showing up**: Restart Claude Desktop and check for the hammer icon
4. **API key errors**: Run the installer again to update your API keys

If a specific MCP server fails to install, the others should still work. You can retry installing the failed server after fixing any issues.

## Features

- **Automatic Detection**: The installer checks if servers are already installed before attempting to install them
- **Configuration Management**: Automatically detects previously configured API keys and only prompts for missing ones
- **Installation Summary**: Provides a clear summary of what was installed and what might have failed
- **Easy Updates**: Run the installer again at any time to update your configuration or add new API keys

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
