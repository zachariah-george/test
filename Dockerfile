# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

SHELL ["cmd", "/S", "/C"]

RUN powershell -Command `
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
        choco feature disable --name showDownloadProgress

RUN choco install -y git `
        visualstudio2019buildtools --package-parameters "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64"

COPY . C:\src

WORKDIR C:\src

RUN git clone https://github.com/apache/apr.git srclib/apr `
        && git clone https://github.com/apache/apr-util.git srclib/apr-util `
        && "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.28.29910\bin\Hostx64\x64\nmake.exe" /f Makefile.win _apache_ `
        && "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.28.29910\bin\Hostx64\x64\nmake.exe" /f Makefile.win installr
