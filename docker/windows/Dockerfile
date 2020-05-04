# For images cached to Github runner see:
#   https://github.com/actions/virtual-environments/blob/master/images/win/Windows2016-Readme.md

FROM mcr.microsoft.com/windows/servercore:ltsc2016 AS buildtools
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

RUN \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install -y lessmsi

RUN \
    Invoke-WebRequest \
    'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe' \
    -OutFile 'visualcppbuildtools_full.exe' \
    -UseBasicParsing

RUN Start-Process .\visualcppbuildtools_full.exe -Wait -ArgumentList '/NoRestart /Quiet /Layout C:\build\layout'

RUN Get-ChildItem C:\build\layout\packages -Filter *.msi -Recurse | % { Write-Host $_.FullName } 

RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_CRT.Headers\VC_CRT.Headers.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_CRT.X64.Store\VC_CRT.X64.Store.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Base\VC_Tools.X64.Base.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat\VC_Tools.X64.Nat.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X64.Nat.Res\enu\VC_Tools.X64.Nat.Res.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualC_D14\VC_Tools.X86.Nat\VC_Tools.X86.Nat.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\VisualCppBuildTools_Core\VisualCppBuildTools_Core.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win10_UniversalCRTSDK\10240\Universal CRT Headers Libraries and Sources-x86_en-us.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win81_SDK\Windows Software Development Kit-x86_en-us.msi" C:\build\'
RUN Start-Process lessmsi -Wait -NoNewWindow -ArgumentList 'x "C:\build\layout\packages\Win81_SDK\Windows Software Development Kit for Windows Store Apps-x86_en-us.msi" C:\build\'

RUN Remove-Item -Recurse "C:\build\SourceDir\Microsoft"
RUN Remove-Item -Recurse "C:\build\SourceDir\Program Files\Microsoft Visual Studio 14.0\VC\lib\store"
RUN Remove-Item -Recurse "C:\build\SourceDir\Reference Assemblies"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\bin"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Catalogs"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\DesignTime"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\arm64"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Lib\10.0.10240.0\ucrt\x86"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\10\Source"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\bin\x86"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\bin\arm"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Catalogs"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\DesignTime"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Include\winrt"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Lib\winv6.3\um\arm"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Lib\winv6.3\um\x86"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Redist"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\References"
RUN Remove-Item -Recurse "C:\build\SourceDir\Windows Kits\8.1\Shortcuts"


FROM mcr.microsoft.com/windows/servercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

ENV BUILDTOOLS "C:\buildtools"
ENV PATH "$env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\bin\amd64;$env:BUILDTOOLS\Windows Kits\8.1\bin\x64;$env:PATH"
ENV INCLUDE "$env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\INCLUDE;$env:BUILDTOOLS\Windows Kits\10\include\10.0.10240.0\ucrt;$env:BUILDTOOLS\Windows Kits\8.1\include\shared;$env:BUILDTOOLS\Windows Kits\8.1\Include\um"
ENV LIB "$env:BUILDTOOLS\Program Files\Microsoft Visual Studio 14.0\VC\LIB\amd64;$env:BUILDTOOLS\Windows Kits\10\Lib\10.0.10240.0\ucrt\x64;$env:BUILDTOOLS\Windows Kits\8.1\lib\winv6.3\um\x64"

COPY --from=buildtools C:\build\SourceDir $env:BUILDTOOLS

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["/entrypoint.ps1"]
