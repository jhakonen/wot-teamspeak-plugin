FROM microsoft/windowsservercore:ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest 'https://go.microsoft.com/fwlink/?LinkId=691126' -OutFile 'visualcppbuildtools_full.exe' -UseBasicParsing ; \
    Start-Process .\visualcppbuildtools_full.exe -ArgumentList '/NoRestart /S' -Wait ; \
    Remove-Item visualcppbuildtools_full.exe

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

COPY entrypoint.sh /entrypoint.ps1

ENTRYPOINT ["/entrypoint.ps1"]
