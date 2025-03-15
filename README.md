# Claude MCP for Marketing Professionals

A simple one-click installer for the most useful Model Context Protocol (MCP) servers for marketing professionals using Claude.

## What is MCP?

Model Context Protocol (MCP) allows Claude to connect with external tools, websites, and data sources—dramatically expanding what it can do for you. With MCP, Claude can search the web, access your files, remember important information, and much more.

## What This Installs

This simple installer automatically configures Claude Desktop with seven essential MCP servers for marketing work:

1. **Brave Search** - For market research and trend analysis
   - Search for the latest industry trends and competitor information
   - Research customer preferences and behavior
   - Find inspiration for campaigns and content
   - **Requires API key:** Get one from [Brave Search API](https://brave.com/search/api/)

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
   - **Requires Slack Bot Token:** Create one at [Slack API](https://api.slack.com/apps)

6. **Bluesky** - For social media content creation and engagement
   - Create and publish Bluesky posts
   - Analyze engagement and community growth
   - Monitor trends and conversations
   - **Requires App Password:** Generate in Bluesky's Settings > Privacy and Security > App Passwords

7. **Perplexity** - For advanced web search and research capabilities
   - Perform in-depth research with source citations
   - Get recent information about marketing trends and news
   - Analyze competitor strategies and market positions
   - **Requires API key:** Obtain from [Perplexity AI](https://perplexity.ai/)

## Installation Instructions

### For Windows Users

1. Download the [marketing-mcp-installer.bat](marketing-mcp-installer.bat) file
2. Double-click the file to run it
3. If prompted about Node.js, follow the installation prompts to install it
4. After installation, you'll need to configure your API keys (see below)
5. Once the installation is complete, restart Claude Desktop
6. Look for the hammer icon in the bottom right of the text input area

### For Mac Users

1. Download the [marketing-mcp-installer.sh](marketing-mcp-installer.sh) file
2. Open Terminal (search for "Terminal" in Spotlight)
3. Type `chmod +x ` (with a space after it)
4. Drag the marketing-mcp-installer.sh file into Terminal and press Enter
5. Now drag the file into Terminal again and press Enter to run it
6. If prompted about Node.js, follow the instructions to install it
7. After installation, you'll need to configure your API keys (see below)
8. Once the installation is complete, restart Claude Desktop
9. Look for the hammer icon in the bottom right of the text input area

## Configuring API Keys

After running the installer, you will need to configure API keys for some of the MCP servers. Edit your Claude Desktop configuration file at:

- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
- **Mac:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux:** `~/.config/Claude/claude_desktop_config.json`

Add environment variables for each service that requires an API key. For example:

```json
{
  "mcpServers": {
    "brave-search": {
      "env": {
        "BRAVE_SEARCH_API_KEY": "YOUR_BRAVE_API_KEY_HERE"
      }
    },
    "perplexity-mcp": {
      "env": {
        "PERPLEXITY_API_KEY": "YOUR_PERPLEXITY_API_KEY_HERE"
      }
    },
    "slack": {
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-YOUR_SLACK_BOT_TOKEN_HERE"
      }
    },
    "bluesky": {
      "env": {
        "BLUESKY_USERNAME": "YOUR_BLUESKY_USERNAME",
        "BLUESKY_APP_PASSWORD": "YOUR_BLUESKY_APP_PASSWORD"
      }
    }
  }
}
```

### How to Get API Keys

1. **Brave Search API Key**: Sign up at [Brave Search API](https://brave.com/search/api/) to get your API key.

2. **Perplexity API Key**: Create an account at [Perplexity AI](https://perplexity.ai/) and get your API key in the account settings.

3. **Slack Bot Token**: 
   - Go to [Slack API Apps](https://api.slack.com/apps)
   - Create a new app
   - Add necessary bot token scopes under "OAuth & Permissions"
   - Install the app to your workspace
   - The token starts with "xoxb-"

4. **Bluesky App Password**:
   - Log in to your Bluesky account
   - Go to Settings > Privacy and Security > App Passwords
   - Create a new app password
