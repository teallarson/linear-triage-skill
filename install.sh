#!/bin/bash

# Linear Triage Skill Installation Script
# This script installs the triage skill for Claude Code

set -e

echo "📦 Installing Linear Triage Skill for Claude Code..."
echo ""

# Check if Claude skills directory exists
SKILLS_DIR="$HOME/.claude/skills"
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Creating Claude skills directory: $SKILLS_DIR"
    mkdir -p "$SKILLS_DIR"
fi

# Copy skill files
echo "Copying skill files..."
if [ -d "$SKILLS_DIR/triage" ]; then
    echo "⚠️  Triage skill already exists. Backing up to triage.backup..."
    mv "$SKILLS_DIR/triage" "$SKILLS_DIR/triage.backup"
fi

cp -r triage "$SKILLS_DIR/"
echo "✅ Skill files copied to $SKILLS_DIR/triage/"

# Check MCP configuration
MCP_CONFIG="$HOME/.config/claude/mcp.json"
echo ""
echo "Checking MCP configuration..."
if [ -f "$MCP_CONFIG" ]; then
    echo "✅ MCP config found at $MCP_CONFIG"

    # Check if arcade-gateway is configured
    if grep -q "arcade-gateway" "$MCP_CONFIG"; then
        echo "✅ arcade-gateway MCP server is configured"
    else
        echo "⚠️  arcade-gateway MCP server NOT found in config"
        echo ""
        echo "Please add the Arcade MCP Gateway to your config:"
        echo "Location: $MCP_CONFIG"
        echo ""
        echo "Example configuration in: example-mcp.json"
        echo ""
        echo "Get your Arcade API key from: https://arcade.dev"
    fi
else
    echo "⚠️  MCP config not found. Creating directory..."
    mkdir -p "$HOME/.config/claude"
    echo ""
    echo "Please create MCP config at: $MCP_CONFIG"
    echo "Use example-mcp.json as a template"
    echo ""
    echo "Get your Arcade API key from: https://arcade.dev"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. If needed, configure Arcade MCP Gateway in: $MCP_CONFIG"
echo "2. Restart Claude Code"
echo "3. Run: /triage"
echo ""
echo "See README.md for detailed setup instructions."
