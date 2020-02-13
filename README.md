# Windows 10 and Ubuntu on Windows Subsystem for Linux (WSL) Setup Guide for Web App Developers

Instructions to make Windows 10 with the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL) setup fast and efficient for developing web apps in Go, C# (.NET Core), Java, Python, and NodeJS, and web front-ends in React. This guide uses Ubuntu 18.04 as the OS running within WSL.

> This guide is written for version 1 of WSL. The setup process described herein has not been tested using WSL2. See [About WSL 2](https://docs.microsoft.com/en-us/windows/wsl/wsl2-about) for more information about the differences between WSL1 and WSL2.

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

1. After restarting your PC from the previous set of steps, visit https://docs.microsoft.com/en-us/windows/wsl/install-manual and select the Ubuntu 18.04 distro. Alternatively, you can download the Ubuntu 18.04 distro at https://aka.ms/wsl-ubuntu-1804.
1. After the download is complete, run the `.appx` file that was downloaded. An installer window will appear. NOTE: _Whatever directory you run the installer from is where WSL will be installed to. You cannot change this directory post-installation._

> If the `.appx` file appears un-runnable in Windows, see the "Manual Appx unpackaging and installation" portion of this guide. Otherwise, continue with step 3 below.

3. Launch the installer. A Windows Command Prompt titled **Ubuntu** will appear with the text `Installing, this may take a few minutes...`
1. After a short while, a prompt will appear asking for a UNIX username. Enter a name you will remember and press **Enter**.
1. A prompt will appear asking for a UNIX password. Enter a strong password and press **Enter**.
1. A prompt will appear asking for you to retype your password. Re-enter the same password you just typed in the previous step and press **Enter**. A Bash prompt appears with your username and machine name, e.g. `username@machinename:~$`
1. Right-click on the Ubuntu app icon in your Windows taskbar and select **Pin to taskbar**.

### Workaround: Manual Appx unpackaging and installation

This section is only meant to work around a problem where Windows 10 doesn't recognize `.appx` files as executable, thus preventing readers from completing the steps outlined in the previous section.

1. Change the extension on the Ubuntu file you downloaded from `.appx` to `.zip`.
1. Open the `zip` file in Windows
1. Elect to extract the contents of the `zip` file to somewhere on your computer.
1. Open the extracted files on your computer
1. Find the installer `exe` file and run it. NOTE: _Whatever directory you run the installer from is where WSL will be installed to. You cannot change this directory post-installation._
1. Resume step 4 from the previous section

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

## Access the C drive from Ubuntu

Accessing Windows files from Ubuntu is possible by navigating to the C drive, which is listed in `mnt`:

```bash
cd /mnt/c
```

## Java and Maven

```bash
sudo apt install openjdk-8-jdk-headless maven
```

Run `javac -version` and look for `javac 1.8.0_222` (or newer) to verify success

## Go

```bash
sudo apt install golang-go
```

Run `go version` and look for `go version go1.10.4 linux/amd64` (or newer) to verify success

## Python

```bash
sudo apt install python3-minimal
```

Run `python3 --version` and look for `Python 3.6.8` (or newer) to verify success

## NodeJS

```bash
sudo apt install build-essential
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install nodejs
```

Run `npm --version` and look for `6.13.7` (or newer) to verify success

Periodically, you will want to update NPM to the latest available version. Do so by running:

```bash
sudo npm install -g npm
```

## .NET Core

```bash
sudo apt install apt-transport-https ca-certificates
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-3.1 -y
rm -f packages-microsoft-prod.deb
```

Run `dotnet --version` and look for `3.1.101` (or newer) to verify success

### Optional: Disable .NET Core telemetry

1. Run `nano ~/.profile`
1. Type `export DOTNET_CLI_TELEMETRY_OPTOUT=true` at the bottom of the file
1. Save and exit
1. Restart the WSL command prompt

> You can also set `DOTNET_SKIP_FIRST_TIME_EXPERIENCE` to `true` when editing `.profile` to fix the following warning that may appear during .NET Core compiles: "Permission denied to modify the '/usr/share/dotnet/sdk/NuGetFallbackFolder' folder."

## Docker and Docker Compose

Next, install the Docker CLI tools in WSL:

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

Running "docker --version" should display "Docker version 19.03.6, build 369ce74a3c" or similar.

Install Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Running "docker-compose --version" should display "docker-compose version 1.25.0, build 0a186604".

Ensure you can run Docker commands without `sudo`:

```bash
sudo usermod -aG docker $USER
```

## Creating a bridge between WSL and a Docker daemon

WSL is currently incapable of running the Docker daemon. The steps described in the previous section - the ones that installed Docker in WSL - will only allow you to run the Docker commands from the command line. With no daemon, those commands will only produce error messages, which is not useful.

The Docker daemon can only run on a Linux server. Therefore, two things are required: 
1. Setting up a Linux server with Docker on it
1. Bridging WSL to the Docker daemon running on that Linux server.

By far, the simplest way to achieve this is by installing _Docker for Windows_. Alternatively, you can create your own Linux-based virtual machine and use port forwarding. Both methods are described below.

### Creating a bridge from WSL to Docker using Docker for Windows

If you're using Docker for Windows, follow the steps below to create the bridge:

1. Open the **Docker for Windows** app in Windows 10 and navigate to the **General** tab.
1. Check the box that says **Expose daemon on tcp://localhost:2375 without TLS**. Docker for Windows will restart momentarily.
1. Return to the Ubuntu command prompt.
1. Run `nano ~/.profile`, add `export DOCKER_HOST=tcp://0.0.0.0:2375` to the end of the file, and save
1. Restart Ubuntu WSL
1. Once Ubuntu WSL is restarted, type `docker run hello-world` and press **Enter**. You should see a lengthy output that says somewhere in the middle, "Hello from Docker!"

### Creating a bridge from WSL to Docker using a Linux VM and VirtualBox

This section assumes one is using VirtualBox and already has an Ubuntu 18.04 virtual machine running.

1. Install Docker and Docker Compose in your Ubuntu virtual machine. https://github.com/erik1066/pop-os-setup contains detailed instructions for how to do this.
1. Open a terminal window in the virtual machine
1. In the _virtual machine terminal_, run `sudo mkdir -p /etc/systemd/system/docker.service.d`
1. In the _virtual machine terminal_, run `sudo nano /etc/systemd/system/docker.service.d/options.conf`. A Nano text editor window opens.
1. Add the following lines to the file:

```bash
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix:// -H tcp://0.0.0.0:2375
```

6. Press `CTRL`+`X` to exit the Nano text editor and save when prompted.
1. In the _virtual machine terminal_, run `sudo systemctl daemon-reload`
1. In the _virtual machine terminal_, run `sudo systemctl restart docker`
1. Back in Windows, open the **VirtualBox Manager** window, select your VM from the list, and then open the **Settings** panel for the VM
1. Navigate to the **Network** tab
1. Under **Attached to**, ensure "NAT" is selected
1. Press **Advanced**. Additional networking options appear.
1. Select **Port Forwarding**. A list of port forwarding rules appears. (The list should be empty unless you've previously set up port forwarding for your VM.)
1. Select the green **New Port Forwarding Rule** button. A new port forwarding rule appears in the list.
1. Use the following options for the rule values:
```
host ip:    0.0.0.0
host port:  2375
guest ip:   10.0.2.15
guest port: 2375
```
16. Press **OK** to save
1. Press **OK** again in the **Network** tab
1. Back in the _WSL terminal_, Run `nano ~/.profile`, add `export DOCKER_HOST=tcp://0.0.0.0:2375` to the end of the file, and save
1. Restart Ubuntu WSL
1. Once Ubuntu WSL is restarted, type `docker run hello-world` and press **Enter**. You should see a lengthy output that says somewhere in the middle, "Hello from Docker!"

> Note that the 10.0.2.15 IP address isn't guaranteed to be the same on your virtual machine. You can verify the VM's actual IP address by opening a terminal window in the VM and running `ifconfig`.

## Azure CLI tools

See [Install Azure CLI with apt](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest) for further information.

```bash
sudo apt-get install apt-transport-https lsb-release software-properties-common dirmngr -y

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

sudo apt-get update
sudo apt-get install azure-cli
```

## Azure Functions Core Tools

`npm` and the .NET Core SDK 2.1 are required to work with the Azure Functions Core Tools. The Azure Functions Core Tools are correspondingly required to work with Azure Functions in Visual Studio Code. 

> This section assumes you've already installed `nodejs` and `npm`. Steps to install these are provided in an earlier section of this guide.

Installing the Azure Functions Core Tools is done using `npm`, but in WSL this presents a problem: The `node_modules` folder in `usr/lib` is owned by `root` and not by your account. Even using `sudo` to run `npm` will therefore fail with an error.

Thus, before installing the tools with the `npm` command, follow the steps below:

1. Run `sudo apt update && sudo apt install dotnet-sdk-2.1 -y` to install the .NET Core SDK 2.1, which is a prerequisite
1. Run `whoami` to verify your username
1. Run `sudo chown -R yourusername: /usr/lib/node_modules`, replacing `yourusername` with the output from the `whoami` command

You can now install the tools using `npm` without encountering an error:

```bash
npm install -g azure-functions-core-tools
```

Be sure to install the [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) and [C#](https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp) extensions for Visual Studio Code.

## AWS CLI tools

```bash
sudo apt install awscli
```

Run `aws --version` to verify success.

> AWS CLI tools can alternatively be installed and updated using `pip` instead of the central repositories. See [Install AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html) for instructions. The benefit of using `pip` is a more up-to-date version of the tools.

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
1. Copy the GPG key ID that starts with `sec`. E.g. in `sec rsa4096/30F2B65B9246B6CA 2017-08-18 [SC]`, the key ID is `30F2B65B9246B6CA`
1. Run `gpg --armor --export 30F2B65B9246B6CA`
1. Run `git config --global user.signingkey 30F2B65B9246B6CA`

To sign commits, the only difference is the addition of the `-S` flag:

```bash
git commit -S -m "My commit msg"
```
