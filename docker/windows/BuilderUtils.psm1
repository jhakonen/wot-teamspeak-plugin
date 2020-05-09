function Invoke-NativeProgram {
    param (
        [ScriptBlock] $ScriptBlock
    )
    Write-Host $ScriptBlock
    $global:LASTEXITCODE = "not-set"
    $ErrorActionPreference = 'Continue'
    & $ScriptBlock.GetNewClosure() 2>&1 >$env:TEMP\out.log
    if ($global:LASTEXITCODE -eq "not-set") {
        throw "Exit code not set, maybe because the native program is GUI application?"
    }
    if (($global:LASTEXITCODE -is [Int32]) -and ($global:LASTEXITCODE -ne 0)) {
        Get-Content $env:TEMP\out.log
        throw "Execution failed with exit code: $global:LASTEXITCODE"
    }
}
