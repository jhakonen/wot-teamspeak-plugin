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

# Fix for servercore:ltsc2016 (should not be an issue in servercore:ltsc2019),
# without this QMake will fail with error:
#   ASSERT: "fileName.isEmpty() || isAbsolutePath(fileName)"
# Solution based on:
#   - https://github.com/nodejs/node/issues/8897#issuecomment-298662512
#   - https://github.com/nodejs/node/issues/8897#issuecomment-319010735
RUN mkdir C:/build
RUN Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices' -Name 'Z:' -Value '\??\C:\build' -Type String
WORKDIR 'Z:\\'

COPY --from=builder ["C:/build/layout/packages/vcRedistD14/VC_redist.x64.exe", "C:/VC_redist.x64.exe"]
COPY --from=builder ["C:/build/SourceDir", "C:/buildtools"]
COPY --from=builder ["C:/build/qt", "C:/qt"]
COPY --from=builder ["C:/python27", "C:/python27"]

COPY ["BuilderUtils.psm1", "C:/Program Files/WindowsPowerShell/Modules/BuilderUtils/BuilderUtils.psm1"]
COPY ["entrypoint.ps1", "C:/entrypoint.ps1"]
COPY ["qmake.exe", "C:/qt/5.12.3/msvc2015_64/bin/qmake.exe"]

# Required at least by cl.exe
RUN Invoke-NativeProgram { cmd /c start /wait 'C:/VC_redist.x64.exe' /install /passive /norestart }

ENTRYPOINT ["powershell.exe", "C:\\entrypoint.ps1"]
