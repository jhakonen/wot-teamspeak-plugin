# For images cached to Github runner see:
#   https://github.com/actions/virtual-environments/blob/master/images/win/Windows2016-Readme.md

FROM mcr.microsoft.com/windows/servercore:ltsc2016 AS builder
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

RUN \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

COPY ["BuilderUtils.psm1", "C:/Program Files/WindowsPowerShell/Modules/BuilderUtils/BuilderUtils.psm1"]

RUN Invoke-NativeProgram { choco install -y lessmsi 7zip python2 }

COPY ["install-buildtools.ps1", "C:/install-buildtools.ps1"]
RUN & C:\install-buildtools.ps1

COPY ["install-qt.ps1", "C:/install-qt.ps1"]
RUN & C:\install-qt.ps1



FROM mcr.microsoft.com/windows/servercore:ltsc2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR /build

RUN \
    SETX BUILDTOOLS_DIR "C:\\buildtools" /M; \
    SETX PYTHON_DIR "C:\\Python27" /M; \
    SETX QT_DIR "C:\\qt\\5.12.3\\msvc2015_64" /M;

RUN \
    SETX PATH "$env:PYTHON_DIR;$env:QT_DIR\\bin;$env:BUILDTOOLS_DIR\\Program Files\\Microsoft Visual Studio 14.0\\VC\\bin\\amd64;$env:BUILDTOOLS_DIR\\Windows Kits\\8.1\\bin\\x64;$env:PATH" /M; \
    SETX INCLUDE "$env:BUILDTOOLS_DIR\\Program Files\\Microsoft Visual Studio 14.0\\VC\\INCLUDE;$env:BUILDTOOLS_DIR\\Windows Kits\\10\\include\\10.0.10240.0\\ucrt;$env:BUILDTOOLS_DIR\\Windows Kits\\8.1\\include\\shared;$env:BUILDTOOLS_DIR\\Windows Kits\\8.1\\Include\\um" /M; \
    SETX LIB "$env:BUILDTOOLS_DIR\\Program Files\\Microsoft Visual Studio 14.0\\VC\\LIB\\amd64;$env:BUILDTOOLS_DIR\\Windows Kits\\10\\Lib\\10.0.10240.0\\ucrt\\x64;$env:BUILDTOOLS_DIR\\Windows Kits\\8.1\\lib\\winv6.3\\um\\x64" /M;

COPY --from=builder ["C:/build/SourceDir", "C:/buildtools"]
COPY --from=builder ["C:/build/qt", "C:/qt"]
COPY --from=builder ["C:/python27", "C:/python27"]

COPY ["BuilderUtils.psm1", "C:/Program Files/WindowsPowerShell/Modules/BuilderUtils/BuilderUtils.psm1"]
COPY ["entrypoint.ps1", "C:/entrypoint.ps1"]

ENTRYPOINT ["powershell.exe", "C:\\entrypoint.ps1"]
