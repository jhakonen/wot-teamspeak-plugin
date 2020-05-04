Invoke-WebRequest `
    'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe' `
    -OutFile 'visualcppbuildtools_full.exe' `
    -UseBasicParsing

Start-Process .\visualcppbuildtools_full.exe -Wait -ArgumentList '/NoRestart /Quiet /Layout C:\build\layout'

Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_CRT.Headers\VC_CRT.Headers.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_CRT.X64.Store\VC_CRT.X64.Store.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Base\VC_Tools.X64.Base.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat\VC_Tools.X64.Nat.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat.Res\enu\VC_Tools.X64.Nat.Res.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X86.Nat\VC_Tools.X86.Nat.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualCppBuildTools_Core\VisualCppBuildTools_Core.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win10_UniversalCRTSDK\10240\Universal CRT Headers Libraries and Sources-x86_en-us.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win81_SDK\Windows Software Development Kit-x86_en-us.msi" C:\build\'
Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win81_SDK\Windows Software Development Kit for Windows Store Apps-x86_en-us.msi" C:\build\'

Remove-Item -Recurse "C:\build\SourceDir\Microsoft"
Remove-Item -Recurse "C:\build\SourceDir\Program Files\Microsoft Visual Studio 14.0\VC\lib\store"
Remove-Item -Recurse "C:\build\SourceDir\Reference Assemblies"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\bin"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Catalogs"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\DesignTime"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm64"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\x86"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Source"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\bin\x86"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\bin\arm"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Catalogs"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\DesignTime"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Include\winrt"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Lib\winv6.3\um\arm"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Lib\winv6.3\um\x86"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Redist"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\References"
Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Shortcuts"
