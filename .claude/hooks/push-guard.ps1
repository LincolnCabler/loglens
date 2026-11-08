# PreToolUse hook: block Claude's "git push" if any tracked file contains an email address.
# Claude Code sends the pending tool call as JSON on stdin.
# Exit 0 = allow. Exit 2 = block; stderr is sent back to Claude.

$payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
$command = $payload.tool_input.command

# Matches "git push" and forms with global options first, like "git -C <path> push".
# "push" must be the git subcommand, so a path such as ".githooks/pre-push" does not match.
$pushPattern = '\bgit(\s+(-[Cc]\s+("[^"]*"|''[^'']*''|\S+)|-\S+))*\s+push\b'
if ($command -notmatch $pushPattern) {
    exit 0   # not a push; let it through
}

$repoRoot = git rev-parse --show-toplevel
& (Join-Path $repoRoot 'scripts/check-emails.ps1')
if ($LASTEXITCODE -ne 0) {
    exit 2
}

exit 0
