---
name: triage
description: Create a new Linear issue by interactively walking through the triage template questionnaire
---

# Triage Issue Creator

## Purpose
This skill helps create new Linear issues by finding a "triage template" issue, parsing its structure, and walking the user through filling it in interactively. It ensures consistent issue creation by following a standardized template.

## When to Use
- When the user asks to create a triage issue
- When invoked with `/triage`
- When the user wants to file a new issue using the triage template
- When standardized issue intake is needed

## Instructions

### Step 0: Verify Linear Connection
Before starting, verify the arcade-gateway MCP is available:
- Attempt to use a Linear tool (e.g., `Linear_WhoAmI` or `Linear_ListTeams`)
- If tools are not accessible, inform the user: "Linear MCP tools are not available. Please check your MCP configuration for 'arcade-gateway'."
- If successful, proceed to Step 1

### Step 1: Find the Triage Template
Use the Linear MCP tool `Linear_ListIssues` to search for the triage template:
```
keywords: "triage template"
limit: 5
```

If multiple results are found, look for:
- Issues with "template" in the title
- Issues in a specific state (e.g., "Backlog" or a template state)
- The most recently updated template

If no template is found:
- Inform the user: "I couldn't find a triage template issue."
- Ask: "Would you like to:
  - Create a standard issue without a template
  - Specify the template issue ID directly
  - List all available issues to find the template"

### Step 2: Fetch Template Details
Use `Linear_GetIssue` to get the full details of the template issue:
- Include the full description
- Note the team, labels, and other metadata
- The description will contain the template structure

### Step 3: Parse Template Structure
The template description typically contains sections that need to be filled in. Common patterns:
- **Markdown headers** (`## Section Name`, `### Field Name`)
- **Form fields** (`**Field:** value` or `Field: value`)
- **Placeholders** (`[FILL IN]`, `TBD`, `TODO`, `...`)
- **Questions** (lines ending with `?`)

Identify which fields need user input:
- Title template
- Problem description
- Steps to reproduce
- Expected vs actual behavior
- Priority level
- Team assignment
- Labels to apply
- Any other custom fields

**If template structure is unclear or doesn't match common patterns:**
- Default to standard fields (title, description, team, priority, labels)
- Ask user: "I found a template but the structure is unclear. Would you like me to:
  - Use standard bug report fields (title, description, reproduction steps, team)
  - Show you the template so you can specify which fields to fill
  - Create a simple issue with just title and description"
- See `reference.md` for detailed parsing strategies and edge case handling

### Step 4: Collect Information Interactively

**IMPORTANT:** Use a conversational approach for detailed fields, and `AskUserQuestion` only for selection-based fields.

**For detailed/free-form fields (title, description, reproduction steps, error messages):**
- Ask the user directly in conversation: "What's the issue title? Please describe the problem and its impact."
- Wait for their text response
- Don't use `AskUserQuestion` for these - it forces them into predefined options
- Collect their full explanation before moving to next field

**For selection-based fields (team, priority, labels):**
- Use `AskUserQuestion` with clear options
- For team selection, use `Linear_ListTeams` first to get available teams
- Provide 2-4 relevant options
- Remember that "Other" is automatically added

**Recommended question flow:**

1. **Ask conversationally:** "What's the issue title? Please describe the problem and its impact clearly."
2. **Ask conversationally:** "Who is impacted by this issue? (e.g., specific customer, enterprise users, internal team, just you)"
3. **Ask conversationally:** "Please provide context: How did you discover this? What product is affected? What was expected vs actual behavior? Include environment details."
4. **Ask conversationally:** "What are the reproduction steps? Do you have a Loom recording URL, screenshots, or can you describe the steps?"
5. **Ask conversationally (optional):** "Do you have any hypotheses on potential fixes?"
6. **Use AskUserQuestion:** Priority level (urgent/high/medium/low)

**Note:** Per the template instructions, all triage issues should be:
- Assigned to **Product** team (they will route to appropriate team)
- Set to **Triage** state
- No specific team assignment needed at creation time

For detailed best practices on question design, see `reference.md`.

### Step 5: Format the Description
Combine the collected information back into the template format:
- Fill in all placeholders with user responses
- Maintain the template's markdown structure
- Preserve any template instructions or guidelines
- Keep consistent formatting (headers, lists, etc.)

### Step 6: Preview and Create the Issue
**Before creating, show a preview to the user:**

Use `AskUserQuestion` to confirm:
```
I'll create this issue:

**Title:** [user's title]
**Team:** [team name]
**Priority:** [priority level]
**Labels:** [label1, label2]

**Description preview:**
[First 3-4 lines of formatted description...]

Create this issue?
Options:
- Yes, create it
- No, let me modify something
- Cancel
```

**If user wants to modify:**
- Ask which fields to change (title/description/team/priority/labels)
- Re-prompt for those specific fields
- Show updated preview
- Allow multiple revision cycles

**If user confirms, create the issue:**

Use `Linear_CreateIssue` with all collected information:
- `team`: "Product" (always - Product team will route appropriately)
- `title`: From user input
- `description`: Formatted template with filled values
- `priority`: From user selection (if provided)
- `state`: "Triage" (always per template instructions)
- `auto_accept_matches`: Set to `false` to be safe with fuzzy matching

### Step 7: Confirm Creation
After successful creation:
- Report the new issue ID and identifier (e.g., "TOO-123")
- Show the issue URL if available
- Summarize what was created: "Created TOO-123 (High priority, Engineering team): 'Login button not working on mobile'"
- Ask if the user wants to create another triage issue: "Would you like to create another triage issue?"

## Template Parsing Examples

### Example 1: Simple Template
```markdown
## Issue Title
[Brief description of the issue]

## Problem Description
What is happening?

## Expected Behavior
What should happen instead?

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Observe the issue]

## Team
[Team name]

## Priority
[Urgent/High/Medium/Low]
```

**Parse this as:**
- Title field (free text)
- Problem description (free text)
- Expected behavior (free text)
- Steps to reproduce (free text or structured list)
- Team (selection from available teams)
- Priority (selection: urgent/high/medium/low)

### Example 2: Detailed Template with Questions
```markdown
## Title
**What component is affected?** [component]

## Description
**What happened?**
[Describe the issue]

**When did it start?**
[Date/time]

**How many users are affected?**
[Number or percentage]

## Classification
- [ ] Bug
- [ ] Feature Request
- [ ] Investigation
- [ ] Documentation

## Severity
**Impact:** [Critical/High/Medium/Low]
**Urgency:** [Immediate/Soon/Eventually]
```

**Parse this as:**
- Extract questions as prompts
- Identify checkboxes for multiple choice
- Map severity fields to priority
- Structure classification as label selection

## Additional Resources

For detailed guidance on advanced scenarios, see `reference.md`:
- **Best Practices:** Template detection, question design, error handling, UX guidelines
- **Common Template Patterns:** Bug reports, feature requests, investigations, custom templates
- **Troubleshooting:** Template not found, validation failures, parsing issues, connection problems
- **Advanced Techniques:** Template caching, batch creation, customization, tool integration

## Notes

### Integration with Linear
This skill uses the arcade-gateway MCP server's Linear tools:
- `Linear_WhoAmI`: Verify connection and get user info
- `Linear_ListIssues`: Search for templates
- `Linear_GetIssue`: Fetch template details
- `Linear_CreateIssue`: Create the new issue
- `Linear_ListTeams`: Get available teams
- `Linear_ListLabels`: Get available labels
- `Linear_ListWorkflowStates`: Get available states

### Customization
The skill adapts to your template structure:
- Works with any markdown-formatted template
- Extracts questions and fields automatically
- Maintains template's organization
- Preserves any boilerplate text

### Related Skills
- `/commit`: For creating commits after fixing issues
- `/review-pr`: For reviewing PRs that address issues

## Example Usage

### Example 1: Basic Triage Flow
```
User: /triage
Claude: I'll help you create a triage issue. Let me verify Linear connection...
        Connected! Now finding the template...
        Found "Triage Template" (TOO-456)

        Let's walk through the template:

        [Shows questions about title, description, team, etc.]

        I'll create this issue:
        Title: Login button not working on mobile
        Team: Engineering
        Priority: High

        Create this issue? [Yes / No, let me modify / Cancel]

User: Yes
Claude: Created new issue TOO-789: "Login button not working on mobile"
        https://linear.app/workspace/issue/TOO-789

        Would you like to create another triage issue?
```

### Example 2: With Modifications
```
User: /triage
Claude: I'll help you create a triage issue from the template...

        The template has several sections to fill in:
        1. Component affected
        2. Problem description
        3. Impact assessment
        4. Proposed priority

        [Collects information interactively]

        I'll create this issue:
        Title: Payment processing timeout
        Team: Backend
        Priority: High
        Labels: bug, payment

        Create this issue? [Yes / No, let me modify / Cancel]

User: No, let me modify
Claude: What would you like to change?
        - Title
        - Description
        - Team
        - Priority
        - Labels
        - Cancel creation

User: Priority
Claude: What priority should this be?
        - Urgent
        - High (currently selected)
        - Medium
        - Low

User: Urgent
Claude: Updated! Here's the new preview:
        Title: Payment processing timeout
        Team: Backend
        Priority: Urgent
        Labels: bug, payment

        Create this issue? [Yes / No, let me modify / Cancel]

User: Yes
Claude: Created TOO-790 (Urgent priority, Backend team)
        https://linear.app/workspace/issue/TOO-790
```
