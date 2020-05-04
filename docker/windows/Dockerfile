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

COPY install-buildtools.ps1 /install-buildtools.ps1
RUN & C:\install-buildtools.ps1


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
