Invoke-WebRequest `
    'http://master.qt.io/online/qtsdkrepository/windows_x86/desktop/qt5_5123/qt.qt5.5123.win64_msvc2015_64/5.12.3-0-201904161237qtbase-Windows-Windows_10-MSVC2015-Windows-Windows_10-X86_64.7z' `
    -OutFile 'qtbase.7z' `
    -UseBasicParsing

Invoke-NativeProgram { & "C:\program files\7-zip\7z.exe" x "C:\build\qtbase.7z" -oC:\build\Qt -r }

$QCONFIG_PRI = "C:\build\qt\5.12.3\msvc2015_64\mkspecs\qconfig.pri"
$QT_CONF = "C:\build\qt\5.12.3\msvc2015_64\bin\qt.conf"
$QT_CONF_CONTENTS = @'
[Paths]
Documentation=../../Docs/Qt-5.12.3
Examples=../../Examples/Qt-5.12.3
Prefix=..
'@

$PSDefaultParameterValues['Out-File:Encoding'] = 'ASCII'
(Get-Content -path $QCONFIG_PRI -Raw) -replace 'QT_EDITION = Enterprise','QT_EDITION = OpenSource' | Set-Content -Path $QCONFIG_PRI
(Get-Content -path $QCONFIG_PRI -Raw) -replace 'QT_LICHECK = licheck.exe','QT_LICHECK =' | Set-Content -Path $QCONFIG_PRI
$QT_CONF_CONTENTS -f 'string' | Out-File $QT_CONF
