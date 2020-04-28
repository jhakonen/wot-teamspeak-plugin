rem Get rid of Windows Driver Kit as vcvarsall.bat would use that instead of Windows 10 SDK
rem For more info see: https://stackoverflow.com/a/32897691 
rmdir /s /q "C:\Program Files (x86)\Windows Kits\10\include\wdf"

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

rem Add a directory with rc.exe to PATH
set PATH=%PATH%;c:\Program Files (x86)\Windows Kits\8.1\bin\x64

qmake "PLUGIN_VERSION = %1%"
nmake package
