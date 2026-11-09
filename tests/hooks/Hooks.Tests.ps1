# Pester tests for the push-guard hooks:
#   scripts/check-emails.ps1      shared email scan
#   .claude/hooks/push-guard.ps1  Claude Code PreToolUse hook
#   .githooks/pre-push            git hook
# Each test builds a throwaway git repo with copies of the scripts, so the real
# repo is never touched. Run: Invoke-Pester -Path tests/hooks -Output Detailed
#
# No literal email address appears in this file: the push guard scans tracked
# files, so one here would block every push. Test addresses are built at runtime.

BeforeAll {
    $script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
    $script:PsExe = (Get-Process -Id $PID).Path   # same PowerShell that runs the tests
    $script:FakeEmail = 'jane.doe' + '@' + 'example.com'
    $script:IsWin = [Environment]::OSVersion.Platform -eq 'Win32NT'

    function New-TestRepo {
        param([switch] $WithEmail)

        $dir = Join-Path ([IO.Path]::GetTempPath()) ("loglens-hooktest-" + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $dir | Out-Null
        git -C $dir init -q 2>$null

        foreach ($rel in 'scripts/check-emails.ps1', '.claude/hooks/push-guard.ps1', '.githooks/pre-push') {
            $target = Join-Path $dir $rel
            New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
            Copy-Item (Join-Path $script:RepoRoot $rel) $target
        }
        if (-not $script:IsWin) { chmod +x (Join-Path $dir '.githooks/pre-push') }

        Set-Content (Join-Path $dir 'notes.txt') 'nothing personal here'
        if ($WithEmail) {
            Set-Content (Join-Path $dir 'leak.txt') "first line`ncontact: $script:FakeEmail"
        }
        git -C $dir add -A 2>$null
        $dir
    }

    function Invoke-Script {
        param([string] $Repo, [string] $Script, [string] $StdIn)

        Push-Location $Repo
        try {
            $output = if ($PSBoundParameters.ContainsKey('StdIn')) {
                $StdIn | & $script:PsExe -NoProfile -ExecutionPolicy Bypass -File $Script 2>&1
            } else {
                & $script:PsExe -NoProfile -ExecutionPolicy Bypass -File $Script 2>&1
            }
            [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output | Out-String) }
        } finally {
            Pop-Location
        }
    }

    function Invoke-PushGuard {
        param([string] $Repo, [string] $Command)

        $json = @{ tool_name = 'Bash'; tool_input = @{ command = $Command } } | ConvertTo-Json -Compress
        Invoke-Script -Repo $Repo -Script '.claude/hooks/push-guard.ps1' -StdIn $json
    }

    $script:CleanRepo = New-TestRepo
    $script:DirtyRepo = New-TestRepo -WithEmail
}

AfterAll {
    foreach ($dir in $script:CleanRepo, $script:DirtyRepo) {
        if ($dir) { Remove-Item -Recurse -Force $dir -ErrorAction SilentlyContinue }
    }
}

Describe 'check-emails.ps1' {
    It 'exits 0 when no tracked file has an email' {
        (Invoke-Script -Repo $CleanRepo -Script 'scripts/check-emails.ps1').ExitCode | Should -Be 0
    }

    It 'exits 1 and names the file and line when a tracked file has an email' {
        $result = Invoke-Script -Repo $DirtyRepo -Script 'scripts/check-emails.ps1'
        $result.ExitCode | Should -Be 1
        $result.Output | Should -Match 'Push blocked'
        $result.Output | Should -Match 'leak\.txt:2'
    }

    It 'ignores untracked files' {
        $repo = New-TestRepo
        try {
            Set-Content (Join-Path $repo 'untracked.txt') "contact: $FakeEmail"
            (Invoke-Script -Repo $repo -Script 'scripts/check-emails.ps1').ExitCode | Should -Be 0
        } finally {
            Remove-Item -Recurse -Force $repo -ErrorAction SilentlyContinue
        }
    }
}

Describe 'push-guard.ps1 (Claude Code PreToolUse hook)' {
    Context 'repo with an email in a tracked file' {
        It 'blocks: <_>' -ForEach @(
            'git push'
            'git push --dry-run origin main'
            'cd repo && git push'
            'git -C "/c/Users/Some User/repo" push --dry-run'
            'git -C repo push'
            'git -c core.x=y push'
            'git --no-pager push'
        ) {
            $result = Invoke-PushGuard -Repo $DirtyRepo -Command $_
            $result.ExitCode | Should -Be 2
            $result.Output | Should -Match 'leak\.txt:2'
        }

        It 'allows non-push command: <_>' -ForEach @(
            'git status'
            'git rm --cached x && git add .githooks/pre-push'
            'git log --grep push'
            'sh .githooks/pre-push'
            'git stash push'
        ) {
            (Invoke-PushGuard -Repo $DirtyRepo -Command $_).ExitCode | Should -Be 0
        }
    }

    Context 'clean repo' {
        It 'allows a push' {
            (Invoke-PushGuard -Repo $CleanRepo -Command 'git push origin main').ExitCode | Should -Be 0
        }
    }
}

Describe 'pre-push (git hook, run by a real git push to a local bare repo)' {
    BeforeEach {
        $script:Remote = Join-Path ([IO.Path]::GetTempPath()) ("loglens-remote-" + [guid]::NewGuid().ToString('N'))
        git init -q --bare $script:Remote 2>$null
    }

    AfterEach {
        Remove-Item -Recurse -Force $script:Remote -ErrorAction SilentlyContinue
    }

    It 'rejects the push when a committed file has an email' {
        $repo = New-TestRepo -WithEmail
        try {
            git -C $repo config core.hooksPath .githooks
            git -C $repo -c user.name=Test -c "user.email=$FakeEmail" commit -q -m test 2>$null
            git -C $repo push -q $Remote HEAD:refs/heads/main 2>$null
            $LASTEXITCODE | Should -Not -Be 0
            git -C $Remote branch --list main | Should -BeNullOrEmpty
        } finally {
            Remove-Item -Recurse -Force $repo -ErrorAction SilentlyContinue
        }
    }

    It 'accepts the push from a clean repo' {
        $repo = New-TestRepo
        try {
            git -C $repo config core.hooksPath .githooks
            git -C $repo -c user.name=Test -c "user.email=$FakeEmail" commit -q -m test 2>$null
            git -C $repo push -q $Remote HEAD:refs/heads/main 2>$null
            $LASTEXITCODE | Should -Be 0
            git -C $Remote branch --list main | Should -Not -BeNullOrEmpty
        } finally {
            Remove-Item -Recurse -Force $repo -ErrorAction SilentlyContinue
        }
    }
}
