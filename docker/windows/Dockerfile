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

COPY --from=builder ["C:/build/SourceDir", "C:/buildtools"]
COPY --from=builder ["C:/build/qt", "C:/qt"]
COPY --from=builder ["C:/python27", "C:/python27"]

COPY ["BuilderUtils.psm1", "C:/Program Files/WindowsPowerShell/Modules/BuilderUtils/BuilderUtils.psm1"]
COPY ["entrypoint.ps1", "C:/entrypoint.ps1"]

ENTRYPOINT ["powershell.exe", "C:\\entrypoint.ps1"]
