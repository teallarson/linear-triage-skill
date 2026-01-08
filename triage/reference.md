# Triage Skill Reference Guide

This document contains detailed best practices, template patterns, and troubleshooting guidance for the triage skill. This information is loaded only when needed for complex scenarios.

## Best Practices

### Template Detection
When searching for the triage template, use these strategies:
- Look for issues with "template" in title or labels
- Check for placeholder patterns: `[...]`, `TBD`, `TODO`, `XXX`
- Identify consistent markdown structure (repeated headers, similar formatting)
- Notice repeated section patterns across the description

### Question Design
Create effective questions for users:

**Be specific**
- Good: "What component is affected?"
- Bad: "Component?"
- Rationale: Specific questions help users provide relevant information

**Provide context**
- Explain why the information is needed
- Example: "Which team should handle this? (This determines who will be notified)"

**Offer choices**
- When there are known valid options, present them as selections
- Example: For priority, offer "urgent / high / medium / low" rather than free text
- Always include "Other" option for flexibility

**Allow text input**
- Always provide "Other" option for flexibility
- Don't force users into predefined categories if their case doesn't fit

**Group related fields**
- Ask about related items together to maintain context
- Example: Ask about "problem description" and "expected behavior" in the same question batch
- Don't interleave unrelated questions (e.g., don't ask "title, team, description, priority" - group logically)

### Error Handling

**Template not found:**
- Inform user clearly: "I couldn't find a triage template issue"
- Offer alternatives:
  - "Would you like me to create a standard issue without a template?"
  - "Would you like to specify the template issue ID directly?"
  - "Should I list all available templates for you to choose from?"
- Don't silently fail or assume

**Team/label validation fails:**
- Use `auto_accept_matches: false` to avoid wrong matches
- Show available options to user: "I found these teams: Engineering, Product, Design. Which should I use?"
- Ask for clarification: "The team 'Eng' is ambiguous. Did you mean 'Engineering' or 'Engine'?"
- Don't guess or use fuzzy matching without confirmation

**Required field empty:**
- Re-prompt with emphasis on requirement
- Example: "Issue title is required. Please provide a brief, descriptive title for the issue."
- Explain why it's required if not obvious

**Creation fails:**
- Show the full error message to user
- Allow retry with modifications: "Would you like to modify the issue details and try again?"
- Offer to skip optional fields: "This might be failing due to invalid labels. Should I try without labels?"

### User Experience

**Pacing:**
- Don't overwhelm with too many questions at once (max 4 per batch)
- Break long questionnaires into logical sections
- Show progress if many fields to fill: "Step 2 of 4: Team and Priority"

**Flexibility:**
- Allow skipping optional fields
- Let users revise answers before final creation
- Provide clear exit points: "Type 'cancel' at any time to stop"

**Confirmation:**
- Always show preview before creating the issue
- Confirm before creating to avoid errors
- Give users chance to modify

**Feedback:**
- Provide clear feedback on what was created
- Include issue ID, identifier, and URL
- Summarize key details: "Created TOO-123 (High priority, Engineering team)"

## Common Template Patterns

Understanding these common patterns helps you parse and adapt to different template structures:

### Bug Report Template
Typical structure for bug reports:
- **Title:** Brief bug description (often 1 line)
- **Description:** What's broken or not working
- **Steps to reproduce:** Numbered list or paragraphs
- **Expected behavior:** What should happen
- **Actual behavior:** What actually happens
- **Environment/version info:** Browser, OS, app version
- **Screenshots or logs:** Attachments or embedded content

**Parsing strategy:**
- Look for "reproduce", "expected", "actual" keywords
- Identify numbered lists for steps
- Map "environment" to labels or description metadata

### Feature Request Template
Typical structure for feature requests:
- **Title:** Feature name or brief description
- **Description:** What is needed
- **Use case:** Why it's needed, who needs it
- **Acceptance criteria:** How to know it's done
- **Priority/impact:** Business value or urgency

**Parsing strategy:**
- Look for "why", "use case", "acceptance" keywords
- Map "impact" to priority field
- Capture "who needs it" for stakeholder info

### Investigation Template
Typical structure for investigations:
- **Title:** What to investigate
- **Description:** Context and symptoms
- **Hypothesis:** Potential causes or areas to explore
- **Team:** Who should investigate
- **Urgency:** How soon this needs attention
- **Success criteria:** What constitutes a complete investigation

**Parsing strategy:**
- Look for "hypothesis", "investigate", "explore" keywords
- Map "urgency" to priority
- Capture context separately from action items

### Custom/Hybrid Templates
Some templates combine multiple patterns or have unique structures:

**Indicators:**
- Multiple sections with different question styles
- Checkboxes for classification: `- [ ] Bug`, `- [ ] Feature`
- Severity matrices: "Impact" + "Urgency" → Priority
- Conditional fields: "If bug, provide steps; if feature, provide use case"

**Parsing strategy:**
- Identify all sections first
- Map checkbox lists to label selections
- Combine related fields (severity dimensions → priority)
- Handle conditional logic by asking classification first

## Troubleshooting

### Issue: Template Not Found

**Symptoms:**
- `Linear_ListIssues` returns no results for "triage template"
- User reports template exists but search doesn't find it

**Solutions:**
1. Try alternative search terms:
   - "template" alone
   - The team name + "template"
   - "intake" or "report" keywords
2. Ask user for template issue ID directly: "Do you know the issue ID (e.g., TOO-123) for the template?"
3. List recent issues and let user identify: Use `Linear_ListIssues` with broader search
4. Offer to create issue without template: Fall back to standard fields

### Issue: Team/Label Validation Fails

**Symptoms:**
- `Linear_CreateIssue` returns error about invalid team/label
- Fuzzy matching selects wrong team

**Solutions:**
1. Use `Linear_ListTeams` to fetch all valid teams before asking user
2. Present teams as explicit options in `AskUserQuestion`
3. Set `auto_accept_matches: false` to prevent incorrect fuzzy matches
4. If team name is ambiguous, show all matches: "Did you mean 'Engineering' (ENG) or 'Engine' (EGN)?"

### Issue: Field Parsing Unclear

**Symptoms:**
- Template structure doesn't match expected patterns
- Can't identify which fields to ask about
- Template is free-form text without clear sections

**Solutions:**
1. Default to standard fields:
   - Title (required)
   - Description (required)
   - Team (required)
   - Priority (optional)
   - Labels (optional)
2. Ask user explicitly: "The template structure is unclear. Would you like me to:
   - Use standard bug report fields
   - Show you the template and let you specify fields
   - Create a simple issue with just title and description"
3. Look for any markdown headers (`##`, `###`) and use those as field names
4. Check for questions (lines ending with `?`) and use those as prompts

### Issue: Description Too Long

**Symptoms:**
- Formatted description exceeds Linear's field limits
- Template has very detailed sections

**Solutions:**
1. Summarize or truncate less critical sections
2. Ask user: "The description is quite long. Should I:
   - Summarize some sections
   - Move detailed content to a comment
   - Create with full description anyway"
3. Consider using comments for supplementary information:
   - Create issue with core description
   - Add detailed info as first comment using `Linear_AddComment`

### Issue: MCP Connection Problems

**Symptoms:**
- Linear tools return connection errors
- `arcade-gateway` MCP server not responding

**Solutions:**
1. Check MCP configuration: Ask user to verify `.mcp.json` includes arcade-gateway
2. Suggest restart: "The Linear MCP connection seems unavailable. Try restarting Claude Code."
3. Verify authentication: "Ensure your Linear API key is configured for the arcade-gateway MCP"
4. Graceful degradation: "I can't connect to Linear right now. Would you like me to help draft the issue text for you to create manually?"

### Issue: User Wants to Modify After Preview

**Symptoms:**
- User reviews preview and wants to change information
- Need to re-collect specific fields

**Solutions:**
1. Ask which fields to modify: "Which would you like to change?
   - Title
   - Description
   - Team
   - Priority
   - Labels
   - Cancel creation"
2. Re-prompt only for selected fields using `AskUserQuestion`
3. Show updated preview before creating
4. Allow multiple revision cycles until user confirms

### Issue: Duplicate Issues

**Symptoms:**
- User accidentally creates same issue twice
- Workflow is re-invoked before first issue completes

**Solutions:**
1. Search for similar issues before creating: Use `Linear_ListIssues` with title keywords
2. Show potential duplicates: "I found similar issues:
   - TOO-123: Login button not working
   - TOO-456: Mobile login issues

   Do you want to:
   - Create new issue anyway
   - View existing issues first
   - Cancel"
3. Track creation state: Don't re-run full workflow if already in progress

## Advanced Techniques

### Template Caching
For efficiency in repeat usage:
- After first template fetch, cache the parsed structure
- Store field names, types, and options
- Reuse for subsequent triage issues in same session
- Clear cache if user specifies different template

### Batch Issue Creation
For creating multiple related issues:
- Ask user: "Do you want to create another issue after this one?"
- Reuse team/label selections for related issues
- Offer to copy common fields (same team, similar priority)
- Keep session active until user exits

### Template Customization
For workspace-specific needs:
- Learn from successful issue creations
- Adapt parsing to recurring patterns
- Suggest template improvements to user
- Document workspace-specific field mappings

### Integration with Other Tools
Enhance workflow by combining with other capabilities:
- **After issue creation:** Offer to link to PR or branch
- **For bugs:** Offer to attach logs or screenshots from local files
- **For investigations:** Offer to search codebase for related issues
- **For features:** Offer to create epic or link to project

## Examples of Handling Edge Cases

### Example 1: Non-Standard Template
**Template content:**
```
Please provide details about the issue. Include all relevant information.
```

**Approach:**
- Recognize this is not a structured template
- Default to standard fields: "This template is free-form. I'll ask for standard information: title, description, team, and priority."
- Use the template text as guidance in question prompts
- Preserve template text as preamble in description

### Example 2: Multi-Language Template
**Template content:**
```
## Title / Título
[English / Español]

## Description / Descripción
[English / Español]
```

**Approach:**
- Ask user for preferred language first
- Adapt question text to chosen language
- Preserve both language sections in final description
- Use template's bilingual format

### Example 3: Conditional Template
**Template content:**
```
## Type
- [ ] Bug → Provide reproduction steps
- [ ] Feature → Provide use case

## Details
[Conditional based on type above]
```

**Approach:**
- Ask classification question first
- Based on answer, ask type-specific follow-ups
- Format description with appropriate sections
- Handle checkboxes by mapping to labels

## Related Documentation

- Linear API Documentation: https://developers.linear.app/docs/graphql/working-with-the-graphql-api
- AskUserQuestion tool: See Claude Code documentation
- arcade-gateway MCP: See MCP server configuration guide
