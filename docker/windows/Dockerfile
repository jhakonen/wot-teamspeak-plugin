# For images cached to Github runner see:
#   https://github.com/actions/virtual-environments/blob/master/images/win/Windows2016-Readme.md

FROM mcr.microsoft.com/windows/servercore:ltsc2016 AS buildtools
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

RUN Invoke-WebRequest \
    'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe' \
    -OutFile 'visualcppbuildtools_full.exe' \
    -UseBasicParsing

RUN Start-Process .\visualcppbuildtools_full.exe -ArgumentList "/NoRestart /Quiet /Layout C:\build\layout" -Wait

RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_Tools.X86.Nat\VC_Tools.X86.Nat.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualCppBuildTools_Core\VisualCppBuildTools_Core.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Base\VC_Tools.X64.Base.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat\VC_Tools.X64.Nat.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\Win81_SDK\Windows Software Development Kit-x86_en-us.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat.Res\enu\VC_Tools.X64.Nat.Res.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_CRT.Headers\VC_CRT.Headers.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\Win10_UniversalCRTSDK\10240\Universal CRT Headers Libraries and Sources-x86_en-us.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\Win81_SDK\Windows Software Development Kit for Windows Store Apps-x86_en-us.msi`" /qn TARGETDIR=C:\build\tools"
RUN Start-Process msiexec -ArgumentList "/a `"C:\build\layout\packages\VisualC_D14\VC_CRT.X64.Store\VC_CRT.X64.Store.msi`" /qn TARGETDIR=C:\build\tools"

RUN Remove-Item -Wait visualcppbuildtools_full.exe
RUN Remove-Item tools\*.msi
RUN Remove-Item -Recurse "tools\Microsoft"
RUN Remove-Item -Recurse "tools\Program Files\Microsoft Visual Studio 14.0\VC\lib\store"
RUN Remove-Item -Recurse "tools\Reference Assemblies"
RUN Remove-Item -Recurse "tools\Windows Kits\10\bin"
RUN Remove-Item -Recurse "tools\Windows Kits\10\Catalogs"
RUN Remove-Item -Recurse "tools\Windows Kits\10\DesignTime"
RUN Remove-Item -Recurse "tools\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm"
RUN Remove-Item -Recurse "tools\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm64"
RUN Remove-Item -Recurse "tools\Windows Kits\10\Lib\10.0.10240.0\ucrt\x86"
RUN Remove-Item -Recurse "tools\Windows Kits\10\Source"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\bin\x86"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\bin\arm"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Catalogs"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\DesignTime"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Include\winrt"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Lib\winv6.3\um\arm"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Lib\winv6.3\um\x86"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Redist"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\References"
RUN Remove-Item -Recurse "tools\Windows Kits\8.1\Shortcuts"


FROM mcr.microsoft.com/windows/servercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

ENV BUILDTOOLS C:\buildtools
ENV PATH $env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\bin\amd64;$env:BUILDTOOLS\Windows Kits\8.1\bin\x64;%PATH%
ENV INCLUDE $env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\INCLUDE;$env:BUILDTOOLS\Windows Kits\10\include\10.0.10240.0\ucrt;$env:BUILDTOOLS\Windows Kits\8.1\include\shared;$env:BUILDTOOLS\Windows Kits\8.1\Include\um
ENV LIB=$env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\LIB\amd64;$env:BUILDTOOLS\Windows Kits\10\Lib\10.0.10240.0\ucrt\x64;$env:BUILDTOOLS\Windows Kits\8.1\lib\winv6.3\um\x64

COPY --from=buildtools C:\build\tools $env:BUILDTOOLS

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["/entrypoint.ps1"]
