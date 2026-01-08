# Linear Triage Skill for Claude Code

A Claude Code skill that streamlines the process of creating Linear triage issues by walking you through an interactive questionnaire based on your team's triage template.

## What This Does

The `/triage` skill:
1. Finds your "triage template" issue in Linear
2. Walks you through filling it in with conversational questions
3. Shows a preview before creating the issue
4. Creates the issue in Linear's Product team with Triage status
5. Product team then routes to the appropriate team

## Features

- **Conversational workflow**: Ask detailed questions conversationally, not just multiple choice
- **Template-based**: Adapts to your organization's triage template structure
- **Smart defaults**: Automatically assigns to Product team with Triage status per template
- **Preview before creation**: Review and modify before posting to Linear
- **Progressive disclosure**: Core workflow loads immediately, detailed reference only when needed

## Prerequisites

1. **Claude Code CLI** - Install from https://github.com/anthropics/claude-code
2. **Arcade MCP Gateway** - For Linear integration
3. **Linear account** - With a triage template issue in your workspace

## Installation

### Step 1: Copy the Skill Files

Copy the `triage` folder to your Claude Code skills directory:

```bash
cp -r triage ~/.claude/skills/
```

Or manually:
```bash
mkdir -p ~/.claude/skills/triage
cp triage/SKILL.md ~/.claude/skills/triage/
cp triage/reference.md ~/.claude/skills/triage/
```

### Step 2: Configure Arcade MCP Gateway

Add the Arcade MCP Gateway to your Claude Code MCP configuration. Create or edit `~/.config/claude/mcp.json`:


**Get your Arcade API key:**
1. Go to https://arcade.dev
2. Navigate to Settings → API Keys
3. Create a new API key
4. Replace `your-arcade-api-key-here` with your actual key

### Step 3: Create a Triage Template in Linear (if you don't have one)

1. Go to your Linear workspace
2. Create a new issue in your Product team
3. Title it something like "Triage template for when you discover a bug or unexpected behavior"
4. Add a description with the fields you want to collect (see example below)
5. The skill will find this template when you run `/triage`

**Example template structure:**
```markdown
Write a title that makes the problem and its impact clear.

**Who:** Describe who the issue impacts (e.g. specific customer, enterprise users, internal team)

**Context:**
* How did this come up?
* What product does this impact?
* What was expected vs actual behavior?
* Include environment details (OS, browser, SDK version)

**Reproduction steps:**
* Record a Loom or include screenshots
* Write out each step to reproduce

**Potential Fixes:** (Optional)
Include any hypotheses on how to resolve

When done, place under Product team with Triage status. Product will route appropriately.
```

### Step 4: Restart Claude Code

Restart Claude Code to load the new skill:
```bash
# Exit and restart claude
```

## Usage

Simply run:
```
/triage
```

The skill will:
1. ✅ Verify Linear connection
2. ✅ Find your triage template
3. ✅ Ask you questions conversationally
4. ✅ Show a preview
5. ✅ Create the issue in Linear

### Example Session

```
You: /triage

Claude: I'll help you create a triage issue. Let me verify Linear connection...
        Connected! Found "Triage Template" (PRO-66)

        What's the issue title? Please describe the problem and its impact clearly.

You: Login button not working on mobile Safari

Claude: Who is impacted by this issue?

You: Enterprise customers on iOS

Claude: Please provide context: How did you discover this? What product is affected?
        What was expected vs actual behavior? Include environment details.

You: Customer reported it. Affects Web UI. Expected: login success,
     Actual: button doesn't respond. iOS 17, Safari.

Claude: What are the reproduction steps? Do you have a Loom recording or screenshots?

You: https://loom.com/share/abc123

Claude: Do you have any hypotheses on potential fixes?

You: Might be a CSS z-index issue with mobile Safari

Claude: What priority should this issue have?
        - Urgent (Critical, blocking work)
        - High (Important, needs attention soon)
        - Medium (Should be addressed)
        - Low (Nice to fix eventually)

You: Urgent

Claude: I'll create this issue:

        Title: Login button not working on mobile Safari
        Team: Product (will be routed appropriately)
        Priority: Urgent
        State: Triage

        [Shows full description preview]

        Create this issue? [Yes / No / Cancel]

You: Yes

Claude: Created PRO-67: "Login button not working on mobile Safari"
        https://linear.app/your-workspace/issue/PRO-67

        Would you like to create another triage issue?
```

## Skill Architecture

The skill uses **progressive disclosure** for token efficiency:

- **SKILL.md** (332 lines) - Core workflow, loaded on every `/triage` invocation
- **reference.md** (344 lines) - Advanced guidance, loaded only when needed for edge cases

This means the skill only loads what's necessary for your specific scenario.

## Customization

### Modify Question Flow

Edit `triage/SKILL.md` Step 4 to customize which questions are asked and in what order.

### Change Default Team/Status

Edit Step 6 in `triage/SKILL.md` to change the default team from "Product" or status from "Triage".

### Add Custom Fields

Add additional fields to collect by modifying the question flow in Step 4 and the description formatting in Step 5.

## Troubleshooting

### "Linear MCP tools are not available"
- Check your `mcp.json` configuration
- Verify your Arcade API key is correct
- Restart Claude Code

### "I couldn't find a triage template issue"
- Make sure you have an issue with "triage template" in the title or description
- Try searching Linear manually for your template
- Create a new template issue if needed

### Authorization Required
- First time using Linear, you'll need to authorize
- Click the authorization link provided
- Once authorized, run the command again

### Skill Not Found
- Verify files are in `~/.claude/skills/triage/`
- Make sure SKILL.md has proper YAML frontmatter
- Restart Claude Code

## File Structure

```
linear-triage-skill/
├── README.md              # This file
├── triage/
│   ├── SKILL.md          # Core skill workflow
│   └── reference.md      # Advanced guidance (progressive disclosure)
└── example-mcp.json      # Example MCP configuration
```

## Contributing

To improve this skill:

1. Make changes to `triage/SKILL.md` or `triage/reference.md`
2. Copy back to `~/.claude/skills/triage/`
3. Test with `/triage`
4. Share improvements with the team

## Credits

Created using Claude Code's skill-creator and agent-reviewer skills.

Based on Arcade's Linear triage template workflow.

## License

MIT License - Feel free to modify and share with your team.

## Questions?

- **Claude Code docs**: https://github.com/anthropics/claude-code
- **Arcade MCP**: https://arcade.dev
- **Linear API**: https://developers.linear.app

---

**Quick Start:** `cp -r triage ~/.claude/skills/ && /triage`
