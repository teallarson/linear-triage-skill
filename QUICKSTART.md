# Quick Start Guide

Get the Linear triage skill working in 5 minutes.

## Installation

```bash
# Clone or download this repo, then:
cd linear-triage-skill
./install.sh
```

## Setup Arcade MCP Gateway

1. Get your Arcade API key from https://arcade.dev (Settings → API Keys)

2. Create or edit `~/.config/claude/mcp.json`:

```json
{
  "mcpServers": {
    "arcade-gateway": {
      "command": "npx",
      "args": ["-y", "@arcade-ai/mcp-server-arcade"],
      "env": {
        "ARCADE_API_KEY": "paste-your-key-here"
      }
    }
  }
}
```

3. Restart Claude Code

## Create Triage Template (if needed)

If your team doesn't have a triage template yet:

1. Go to Linear
2. Create a new issue in Product team
3. Title: "Triage template for bugs and issues"
4. Copy the template from `TEMPLATE-EXAMPLE.md` into the description
5. Save the issue

## Usage

```
/triage
```

That's it! The skill will guide you through the rest.

## First Run

The first time you use it, you'll need to authorize Linear:
1. Click the authorization link
2. Approve the connection
3. Run `/triage` again

## Example

```
You: /triage

Claude: What's the issue title?
You: API timeout on user login

Claude: Who is impacted?
You: All production users

Claude: Please provide context...
You: Started at 2pm EST. Login API timing out after 30s.
     Expected: login success in <2s. Running on AWS us-east-1.

Claude: What are the reproduction steps?
You: 1. Go to app.example.com/login
     2. Enter any valid credentials
     3. Click "Sign In"
     4. Wait 30s and see timeout error

Claude: Any potential fixes?
You: Might be database connection pool exhausted

Claude: What priority?
You: [Select Urgent]

Claude: [Shows preview]
        Create this issue? [Yes]

Claude: Created PRO-123 ✅
        https://linear.app/your-workspace/issue/PRO-123
```

## Troubleshooting

**Skill not found?**
- Run `./install.sh` again
- Check files are in `~/.claude/skills/triage/`
- Restart Claude Code

**MCP not working?**
- Check your API key in `~/.config/claude/mcp.json`
- Verify you have internet connection
- Try restarting Claude Code

**Template not found?**
- Make sure your Linear issue has "triage template" in the title
- Try searching Linear for your template manually
- Create a new template using `TEMPLATE-EXAMPLE.md`

## Need Help?

- See full documentation in `README.md`
- Check `TEMPLATE-EXAMPLE.md` for template format
- Review your Linear triage template issue

---

**That's it! You're ready to create triage issues efficiently. 🚀**
