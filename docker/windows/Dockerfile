# For images cached to Github runner see:
#   https://github.com/actions/virtual-environments/blob/master/images/win/Windows2016-Readme.md

FROM mcr.microsoft.com/windows/servercore:ltsc2016 AS builder
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

RUN \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN & choco install -y lessmsi 7zip python2 > C:\build\out.log; \
    if (-not $?) { cat C:\build\out.log }

COPY install-buildtools.ps1 /install-buildtools.ps1
RUN & C:\install-buildtools.ps1

COPY install-qt.ps1 /install-qt.ps1
RUN & C:\install-qt.ps1



FROM mcr.microsoft.com/windows/servercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

ENV BUILDTOOLS_DIR "C:\buildtools"
ENV PYTHON_DIR "C:\Python27"
ENV QT_DIR "C:\qt\5.12.3\msvc2015_64"

ENV PATH "$env:PYTHON_DIR;$env:QT_DIR\bin;$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\bin\amd64;$env:BUILDTOOLS_DIR\Windows Kits\8.1\bin\x64;$env:PATH"
ENV INCLUDE "$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\INCLUDE;$env:BUILDTOOLS_DIR\Windows Kits\10\include\10.0.10240.0\ucrt;$env:BUILDTOOLS_DIR\Windows Kits\8.1\include\shared;$env:BUILDTOOLS_DIR\Windows Kits\8.1\Include\um"
ENV LIB "$env:BUILDTOOLS_DIR\Program Files\Microsoft Visual Studio 14.0\VC\LIB\amd64;$env:BUILDTOOLS_DIR\Windows Kits\10\Lib\10.0.10240.0\ucrt\x64;$env:BUILDTOOLS_DIR\Windows Kits\8.1\lib\winv6.3\um\x64"

COPY --from=builder /build/SourceDir /buildtools
COPY --from=builder /build/qt /qt
COPY --from=builder /python27 /python27

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["/entrypoint.ps1"]
