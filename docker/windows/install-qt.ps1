Invoke-WebRequest `
    'http://master.qt.io/online/qtsdkrepository/windows_x86/desktop/qt5_5123/qt.qt5.5123.win64_msvc2015_64/5.12.3-0-201904161237qtbase-Windows-Windows_10-MSVC2015-Windows-Windows_10-X86_64.7z' `
    -OutFile 'qtbase.7z' `
    -UseBasicParsing

Exec-NativeProgram { & "C:\program files\7-zip\7z.exe" x "C:\build\qtbase.7z" }
