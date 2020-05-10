$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$BUILDTOOLS_DIR = "C:\buildtools"
$PYTHON_DIR = "C:\Python27"
$QT_DIR = "C:\qt\5.12.3\msvc2015_64"

$env:PATH = @(
    "$PYTHON_DIR",
    "$QT_DIR\bin",
    "$BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\bin\amd64",
    "$BUILDTOOLS_DIR\Windows Kits\8.1\bin\x64",
    "$env:PATH"
) -Join ';'

$env:INCLUDE = @(
    "$BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\INCLUDE",
    "$BUILDTOOLS_DIR\Windows Kits\10\include\10.0.10240.0\ucrt",
    "$BUILDTOOLS_DIR\Windows Kits\8.1\include\shared",
    "$BUILDTOOLS_DIR\Windows Kits\8.1\Include\um"
) -Join ';'

$env:LIB = @(
    "$BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\LIB\amd64",
    "$BUILDTOOLS_DIR\Windows Kits\10\Lib\10.0.10240.0\ucrt\x64",
    "$BUILDTOOLS_DIR\Windows Kits\8.1\lib\winv6.3\um\x64"
) -Join ';'

Get-ChildItem env: | Format-List

qmake -query

Write-Host "START"
cl -nologo -E  C:/qt/5.12.3/msvc2015_64/mkspecs/features/data/macros.cpp
Write-Host "Result: $LASTEXITCODE"

Invoke-NativeProgram { qmake -d "PLUGIN_VERSION = $1" }
Invoke-NativeProgram { nmake package }
