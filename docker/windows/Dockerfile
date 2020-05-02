# For images cached to Github runner see:
#   https://github.com/actions/virtual-environments/blob/master/images/win/Windows2016-Readme.md
FROM mcr.microsoft.com/windows/servercore:ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

COPY AdminDeployment.xml /AdminDeployment.xml

RUN \
    Invoke-WebRequest \
        'http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe' \
        -OutFile 'visualcppbuildtools_full.exe' \
        -UseBasicParsing ; \
    Start-Process .\visualcppbuildtools_full.exe \
         -ArgumentList '/NoRestart /Quiet /AdminFile C:\AdminDeployment.xml /Log vs.log' \
         -Wait ; \
    Remove-Item visualcppbuildtools_full.exe

# RUN cat vs.log

RUN Write-Host 'Configuring environment'; \
  pushd 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC' ; \
  cmd /c 'vcvarsall.bat amd64&set' | foreach { \
    if ($_ -match '=') { \
      $v = $_.split('='); \
      [Environment]::SetEnvironmentVariable($v[0], $v[1], [EnvironmentVariableTarget]::Machine); \
    } \
  } ; \
  popd

WORKDIR /build

COPY entrypoint.ps1 /entrypoint.ps1

ENTRYPOINT ["/entrypoint.ps1"]
