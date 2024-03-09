FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install PHP
RUN powershell -Command "Invoke-WebRequest -Uri https://aka.ms/install-php.ps1 -OutFile install-php.ps1" && \
    powershell -ExecutionPolicy Bypass -File install-php.ps1 -InstallDir C:\php -Version 7.4 -Architecture x64 -Verbose

# Create website directory
WORKDIR C:/inetpub/wwwroot
RUN New-Item -ItemType Directory -Path "C:/inetpub/wwwroot" -Name "website"

# Create index.php file with some content
RUN echo "<?php echo 'Hello, World! This is index.php'; ?>" > C:/inetpub/wwwroot/website/index.php

# Download necessary files
RUN powershell -Command "Invoke-WebRequest -Uri https://gitlab.com/chamod12/ngrok-win10-rdp/-/raw/main/Downloads.bat -OutFile Downloads.bat" && \
    Downloads.bat

# Set NGROK_AUTH_TOKEN environment variable
ENV NGROK_AUTH_TOKEN=${{ secrets.NGROK_AUTH_TOKEN }}

# Add authtoken to ngrok config
RUN ngrok config add-authtoken $env:NGROK_AUTH_TOKEN

# Run Acess.bat and startaudio.bat
RUN Acess.bat
RUN startaudio.bat
