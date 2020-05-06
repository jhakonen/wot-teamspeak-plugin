function Invoke-NativeProgram {
    param (
        [ScriptBlock] $ScriptBlock
    )
    Write-Host $ScriptBlock
    & $ScriptBlock 2>&1 >$env:TEMP\out.log
    if (!$?) {
        Get-Content $env:TEMP\out.log
        throw "Execution failed"
    }
}
