# Install the Gemini CLI tool using Chocolatey and npm
choco install nodejs-lts -y --execution-timeout 3600;
setx PATH "%PATH%;%AppData%\npm";
elevate npm install -g @google/gemini-cli;
