$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

setx BUILDTOOLS_DIR "C:\buildtools"
setx PYTHON_DIR "C:\Python27"
setx QT_DIR "C:\qt\5.12.3\msvc2015_64"

setx PATH "$env:PYTHON_DIR;$env:QT_DIR\bin;$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\bin\amd64;$env:BUILDTOOLS_DIR\Windows Kits\8.1\bin\x64;$env:PATH"
setx INCLUDE "$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\INCLUDE;$env:BUILDTOOLS_DIR\Windows Kits\10\include\10.0.10240.0\ucrt;$env:BUILDTOOLS_DIR\Windows Kits\8.1\include\shared;$env:BUILDTOOLS_DIR\Windows Kits\8.1\Include\um"
setx LIB "$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\LIB\amd64;$env:BUILDTOOLS_DIR\Windows Kits\10\Lib\10.0.10240.0\ucrt\x64;$env:BUILDTOOLS_DIR\Windows Kits\8.1\lib\winv6.3\um\x64"

Get-ChildItem env: | Format-List

Invoke-NativeProgram { qmake "PLUGIN_VERSION = $1" }
Invoke-NativeProgram { nmake package }
