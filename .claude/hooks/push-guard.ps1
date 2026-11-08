# PreToolUse hook: block "git push" if any tracked file contains an email address.
# Claude Code sends the pending tool call as JSON on stdin.
# Exit 0 = allow. Exit 2 = block; stderr is sent back to Claude.

$payload = [Console]::In.ReadToEnd() | ConvertFrom-Json
$command = $payload.tool_input.command

if ($command -notmatch '\bgit\s+push\b') {
    exit 0   # not a push; let it through
}

$repoRoot = git rev-parse --show-toplevel
$emailPattern = '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'

$files = git -C $repoRoot ls-files | ForEach-Object { Join-Path $repoRoot $_ }
$hits = Select-String -LiteralPath $files -Pattern $emailPattern

if ($hits) {
    $list = ($hits | ForEach-Object { "$($_.Path):$($_.LineNumber)" }) -join "`n"
    [Console]::Error.WriteLine("Push blocked: email address found in tracked files:`n$list`nRemove it, commit, then push again.")
    exit 2
}

exit 0
