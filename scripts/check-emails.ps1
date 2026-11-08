# Scans every tracked file for email addresses.
# Exit 0 = clean. Exit 1 = found; the matches are written to stderr.
# Shared by the Claude Code hook (.claude/hooks/push-guard.ps1) and the git
# pre-push hook (.githooks/pre-push), so both enforce the same rule.

$repoRoot = git rev-parse --show-toplevel
$emailPattern = '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'

$files = git -C $repoRoot ls-files | ForEach-Object { Join-Path $repoRoot $_ }
$hits = Select-String -LiteralPath $files -Pattern $emailPattern

if ($hits) {
    $list = ($hits | ForEach-Object { "$($_.Path):$($_.LineNumber)" }) -join "`n"
    [Console]::Error.WriteLine("Push blocked: email address found in tracked files:`n$list`nRemove it, commit, then push again.")
    exit 1
}

exit 0
