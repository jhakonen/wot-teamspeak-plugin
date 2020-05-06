function Invoke-NativeProgram {
    param (
        [ScriptBlock] $ScriptBlock
    )
    Write-Host $ScriptBlock
    & $ScriptBlock 2>&1 >$env:TEMP\out.log
    if ($LASTEXITCODE -eq "") {
        throw "Exit code not set, maybe because the native program is GUI application?"
    }
    if ($LASTEXITCODE -ne "0") {
        Get-Content $env:TEMP\out.log
        throw "Execution failed with exit code: $LASTEXITCODE"
    }
}
