# Windows 10 and Ubuntu on Windows Subsystem for Linux (WSL) Setup Guide for Microservice and Web App Developers

Instructions to make Windows 10 with the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL) setup fast and efficient for developing web services in C# (.NET Core), Java, GoLang, and NodeJS, and web front-ends in React. This guide uses Ubuntu 18.04 as the OS running within WSL.

## Turn on Windows Subsystem for Linux

WSL is not enabled in Windows 10 by default. To enable it:

1. Close all open applications as a reboot will be required later
1. Open the Windows start menu
1. Start typing "turn windows features". Observe the first and only item in the search results is **Turn Windows features on and off**.
1. Select **Turn Windows features on and off** from the search results. An elevated prompt appears.
1. Verify the publisher is displayed as **Microsoft Windows** in the elevated prompt.
1. Enter your administrator account credentials into the elevated prompt and proceed. A **Windows Features** dialog box appears.
1. Scroll to the bottom of the list of features and check the box next to **Windows Subsystem for Linux**.
1. Press **Ok**. An installer dialog with a progress bar appears. When it's done, you will be prompted to reboot. Select **Restart now**.

## Install Windows Subsystem for Linux

The [Windows 10 App Store](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6) is the most straightforward way to install Ubuntu in WSL. Some organizations disallow use of the app store on their Windows machines, in which case you must install Ubuntu manually:

1. After restarting your PC from the previous set of steps, visit https://docs.microsoft.com/en-us/windows/wsl/install-manual and select the Ubuntu 18.04 distro. A download will start.
1. After the download is complete, run the file that was downloaded. An installer window will appear. NOTE: _Whatever directory you run the installer from is where WSL will be installed to. You cannot change this directory post-installation._
1. Launch the installer. A Windows Command Prompt titled **Ubuntu** will appear with the text `Installing, this may take a few minutes...`
1. After a short while, a prompt will appear asking for a UNIX username. Enter a name you will remember and press **Enter**.
1. A prompt will appear asking for a UNIX password. Enter a strong password and press **Enter**.
1. A prompt will appear asking for you to retype your password. Re-enter the same password you just typed in the previous step and press **Enter**. A Bash prompt appears with your username and machine name, e.g. `username@machinename:~$`
1. Right-click on the Ubuntu app icon in your Windows taskbar and select **Pin to taskbar**.

## Update the OS and install common tools

The first thing you should do is get the latest security updates:

```bash
sudo apt update && sudo apt dist-upgrade -y
```

Next, install some common tools you'll need later:

```bash
sudo apt install \
openjdk-8-jdk-headless \
maven \
build-essential \
apt-transport-https \
ca-certificates \
curl \
software-properties-common \
apache2-utils \
make
```

## Change Colors

Users interact with WSL through the Windows 10 Command Prompt. To change the colors for the Command Prompt, left-click on the Ubuntu icon on the top-left corner of the WSL window and select **Properties** > **Colors**.

## Java and Maven

```bash
sudo apt install openjdk-8-jdk-headless maven
```

Run `javac -version` and look for `javac 1.8.0_191` (or newer) to verify success

## Go

```bash
sudo apt install golang-go
```

Run `go version` and look for `go version go1.10.4 linux/amd64` (or newer) to verify success

## NodeJS

```bash
sudo apt install build-essential
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install nodejs
```

Run `npm --version` and look for `6.5.0` (or newer) to verify success

## .NET Core

```bash
sudo apt install apt-transport-https ca-certificates
cd ~/Downloads
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-2.2 -y
rm -f packages-microsoft-prod.deb
```

Run `dotnet --version` and look for `2.2.105` (or newer) to verify success

### Optional: Disable .NET Core telemetry

1. Run `nano ~/.profile`
1. Type `export DOTNET_CLI_TELEMETRY_OPTOUT=true` at the bottom of the file
1. Type `export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true` at the bottom of the file
1. Save and exit
1. Restart the WSL command prompt

> Setting `DOTNET_SKIP_FIRST_TIME_EXPERIENCE` to `true` doesn't affect telemtry. It's a fix for the following warning that may appear during .NET Core compilation: "Permission denied to modify the '/usr/share/dotnet/sdk/NuGetFallbackFolder' folder."

## Docker and Docker Compose

WSL is incapable of running the Docker daemon. To use Docker commands in a WSL terminal, you must send them to _Docker for Windows_ for execution. Setting up this bridge is not straightforward and poorly documented, but it can be done with just a few steps.

1. Install Docker for Windows
1. Return to the Ubuntu command prompt
1. Run the following commands:

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
```

Running "sudo apt-key fingerprint 0EBFCD88" should display:

```
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

Next, run:

```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
docker --version
```

Running "docker --version" should display "Docker version 18.09.4, build d14af54266" or similar.

Install Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Running "docker-compose --version" should display "docker-compose version 1.24.0, build 0aa59064" or similar.

Ensure you can run Docker commands without `sudo`:

```bash
sudo usermod -aG docker $USER
```

Following the above commands will install Docker in WSL, but again, the daemon will not start. Follow the instructions below to create a bridge between Docker in WSL and Docker for Windows:

1. Open the **Docker for Windows** app in Windows 10 and navigate to the **General** tab.
1. Check the box that says **Expose daemon on tcp://localhost:2375 without TLS**. Docker for Windows will restart momentarily.
1. Return to the Ubuntu command prompt.
1. Run `nano ~/.profile`, add `export DOCKER_HOST=tcp://0.0.0.0:2375` to the end of the file, and save
1. Restart Ubuntu WSL
1. Once Ubuntu WSL is restarted, type `docker run hello-world` and press **Enter**. You should see a lengthy output that says somewhere in the middle, "Hello from Docker!"

## Git configuration

```bash
git config --global user.name "Your Name"
git config --global user.email yourname@yourdomain.com
```

See [Customizing Git Configuration](https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) for more details. You can edit the global Git config file by running `nano ~/.gitconfig` in a terminal window. 

## SSH Keys for GitHub/GitLab

1. Run `ssh-keygen -o -t rsa -b 4096 -C "your comment goes here"`
1. Enter a passphrase
1. Run `cat ~/.ssh/id_rsa.pub`
1. Copy the output from `cat` and paste it into GitLab and GitHub's SSH key sections for your profile
1. Run `ssh -T git@gitlab.com` to verify the key is recognized and working with GitLab
1. Run `ssh -T git@github.com` to verify the key is recognized and working with GitHub.com

## GPG Keys for signing commits

Taken from https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/index.html. 

1. Run `gpg --full-gen-key`
1. Choose "RSA"
1. Choose 4096 bits
1. Choose 2y (or a timeframe of your choosing)
1. Provide the other required inputs
1. Run `gpg --list-secret-keys --keyid-format LONG mr@robot.sh` (replace `mr@robot.sh` with the email you used previously)
1. Copy the GPG key ID that starts with `sec`. E.g. in `sec   rsa4096/30F2B65B9246B6CA 2017-08-18 [SC]`, the key ID is `30F2B65B9246B6CA`
1. Run `gpg --armor --export 30F2B65B9246B6CA`
1. Run `git config --global user.signingkey 30F2B65B9246B6CA`

To sign commits, the only difference is the addition of the `-S` flag:

```bash
git commit -S -m "My commit msg"
```