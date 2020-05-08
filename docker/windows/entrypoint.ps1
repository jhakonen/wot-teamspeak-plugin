$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

Get-ChildItem env:

Invoke-NativeProgram { qmake "PLUGIN_VERSION = $1" }
Invoke-NativeProgram { nmake package }
