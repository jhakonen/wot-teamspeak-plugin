function Exec-NativeProgram {
    param (
        [ScriptBlock] $ScriptBlock
    )
    & $ScriptBlock 2>&1 >$env:TEMP\out.log
    if ($LASTEXITCODE -ne 0) {
        Get-Content $env:TEMP\out.log
        throw "Execution failed with exit code: $LASTEXITCODE"
    }
}
