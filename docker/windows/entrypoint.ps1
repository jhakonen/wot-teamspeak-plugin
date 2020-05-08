$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Get-ChildItem env: | Format-List

Invoke-NativeProgram { qmake "PLUGIN_VERSION = $1" }
Invoke-NativeProgram { nmake package }
