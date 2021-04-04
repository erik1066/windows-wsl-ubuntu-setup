# Windows 10 and Ubuntu 20.04 on Windows Subsystem for Linux (WSL) v1 Setup Guide for Software Developers

Instructions to setup and install Windows 10 with the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) (WSL) and Ubuntu 20.04. This guide includes steps for installing Go, Rust, C# (.NET Core), Java, Python, NodeJS, React tooling, Docker and Docker Compose, and various CLI tools for AWS, Azure, and GitHub. Additionally, this guide shows how to create a bridge between WSLv1 and a separate Linux-based VM so that `docker` commands running in WSLv1 will function.

> This guide is written for version 1 of WSL. The setup process described herein has not been tested using WSL2. See [About WSL 2](https://docs.microsoft.com/en-us/windows/wsl/wsl2-about) for more information about the differences between WSL1 and WSL2. You can check what version of WSL you are on by opening a Windows PowerShell Terminal and running `wsl --list --verbose`.

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

1. After restarting your PC from the previous set of steps, visit https://docs.microsoft.com/en-us/windows/wsl/install-manual and select the Ubuntu 20.04 distro. Alternatively, you can download the Ubuntu 20.04 distro at https://aka.ms/wslubuntu2004.
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
openjdk-11-jdk-headless \
maven \
build-essential \
apt-transport-https \
ca-certificates \
curl \
software-properties-common \
apache2-utils \
make \
gnupg2
```

## Change Colors

By default, the way to interact with WSL is through the Windows 10 Command Prompt. To change the colors for the Command Prompt, left-click on the Ubuntu icon on the top-left corner of the WSL window and select **Properties** > **Colors**.

An open source alternative to Windows Command Prompt is available from Microsoft: The [Windows Terminal](https://github.com/Microsoft/Terminal). Changing text colors in the Windows Terminal is currently done using a Json configuration file.

## Access the C drive from Ubuntu

Accessing Windows files from Ubuntu is possible by navigating to the C drive, which is listed in `mnt`:

```bash
cd /mnt/c
```

## Java and Maven

```bash
sudo apt install openjdk-11-jdk-headless maven
```

Run `javac -version` and look for the following output to verify success:

```
openjdk version "11.0.10" 2021-01-19
OpenJDK Runtime Environment (build 11.0.10+9-Ubuntu-0ubuntu1.20.04)
OpenJDK 64-Bit Server VM (build 11.0.10+9-Ubuntu-0ubuntu1.20.04, mixed mode, sharing)
```

## Go

```bash
sudo apt install golang-go
```

Run `go version` and look for `go version go1.13.8 linux/amd64` (or newer) to verify success

## Rust

```bash
sudo apt install cargo
```

Run `rustc --version` to verify success.

**Alternative Rust installation:** Instead of using `apt`, you can use `curl` to download and install Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Restart your WSL terminal session, run `rustc --version`, and look for `rustc 1.41.1 (f3e1a954d 2020-02-24)` (or newer) to verify success.

The `curl` version of installing Rust will install a newer version than what is found in the Ubuntu package manager. It also includes `rustup`, a CLI utility for keeping your Rust installation up-to-date. You use `rustup` like so:

```bash
rustup update
```

## Python

```bash
sudo apt install python3-minimal
```

Run `python3 --version` and look for `Python 3.8.5` (or newer) to verify success

## NodeJS

The quick way to install NodeJS 14 (LTS):

```bash
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs npm
```

Run `node --version` and look for `v14.16.0` (or newer) to verify success.

### Optional: Install NodeJS with a manual inspection of the shell script

If you wish to inspect the shell script before running it:

```bash
cd ~
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
nano nodesource_setup.sh
```

Run the following if you're satisfied with the script:

```bash
sudo bash nodesource_setup.sh
sudo apt install nodejs
```

## .NET Core

```bash
sudo apt install apt-transport-https ca-certificates
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-3.1 dotnet-sdk-5.0 -y
rm -f packages-microsoft-prod.deb
```

Run `dotnet --list-sdks` and look for the following output to verify success:

```
3.1.407 [/usr/share/dotnet/sdk]
5.0.201 [/usr/share/dotnet/sdk]
```

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

Running "docker --version" should display "Docker version 20.10.5, build 55c4c88" or similar.

Install Docker Compose:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Running `docker-compose --version` should display `docker-compose version 1.28.6, build 5db8d86f`.

Ensure you can run Docker commands without `sudo`:

```bash
sudo usermod -aG docker $USER
```

## Creating a bridge between WSL and a Docker daemon

WSL version 1 is incapable of running the Docker daemon. The steps described in the previous section - the ones that installed Docker in WSL - will only allow you to run `docker` commands from the command line. Without the Docker daemon, however, those commands will not be capable of anything more than displaying error messages.

The Docker daemon can only run on a Linux-based operating system. Therefore, two things are required: 

1. Setting up a Linux-based virtual machine with Docker on it
1. Bridging WSL to the Docker daemon running on that Linux virtual machine

By far, the simplest way to achieve this is by installing _Docker for Windows_. Docker for Windows creates its own Linux-based VM using Microsoft's Hyper-V hypervisor. Alternatively, you can create your own Linux-based virtual machine using the hypervisor of your choice and use port forwarding. Both methods are described below.

### Creating a bridge from WSL to Docker using Docker for Windows

If you're using Docker for Windows, follow the steps below to create the bridge:

1. Open the **Docker for Windows** app in Windows 10 and navigate to the **General** tab.
1. Check the box that says **Expose daemon on tcp://localhost:2375 without TLS**. Docker for Windows will restart momentarily.
1. Return to the Ubuntu command prompt.
1. Run `nano ~/.profile`, add `export DOCKER_HOST=tcp://0.0.0.0:2375` to the end of the file, and save
1. Restart Ubuntu WSL
1. Once Ubuntu WSL is restarted, type `docker run hello-world` and press **Enter**. You should see a lengthy output that says somewhere in the middle, "Hello from Docker!"

### Creating a bridge from WSL to Docker using a Linux VM and VirtualBox

This section assumes one is using VirtualBox and already has an Ubuntu 20.04 virtual machine running.

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

```bash
# Get packages needed for the install process:
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

# Download and install the Microsoft signing key:
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add the Azure CLI software repository:
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# Update repository information and install the azure-cli package:
sudo apt-get update
sudo apt-get install azure-cli
```

Verify success by running `az --version` and checking that `azure-cli 2.21.0` (or newer) appears somewhere in the output. Additionally, the output should indicate that `Your CLI is up-to-date`.

> See [Install Azure CLI with apt](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest) for further information.

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

The following script installs v2 of the AWS CLI tools:

```bash
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo ./aws/install
```

Run `aws --version` and check for `aws-cli/2.1.34 Python/3.8.8 Linux/4.4.0-19041-Microsoft exe/x86_64.ubuntu.20 prompt/off` to verify success.

> See https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html for additional information.

## GitHub CLI tools

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh
```

> See https://github.com/cli/cli/blob/trunk/docs/install_linux.md for troubleshooting tips.

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

Taken and adapted from https://help.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key.

1. Run `gpg2 --full-generate-key`
1. Choose the default algorithms when prompted (should be "RSA and RSA")
1. Choose 4096 bits
1. Choose 2y (or a timeframe of your choosing)
1. Provide the other required inputs. _Be sure to write down your GPG password_.
1. Run `gpg2 --list-secret-keys --keyid-format LONG mr@robot.sh` (replace `mr@robot.sh` with the email you used previously)
1. Copy the GPG key ID that starts with `sec`. E.g. in `sec rsa4096/30F2B65B9246B6CA 2017-08-18 [SC]`, the key ID is `30F2B65B9246B6CA`
1. Run `gpg2 --armor --export 30F2B65B9246B6CA`. (This command displays the ASCII output you need to enter in your GitHub user account settings to sign commits with this key. See [Adding a new GPG key to your GitHub account](https://help.github.com/en/github/authenticating-to-github/adding-a-new-gpg-key-to-your-github-account) for instructions.)
1. Run `git config --global user.signingkey 30F2B65B9246B6CA`
1. Run `git config --global gpg.program gpg2`

To sign commits, the only difference is the addition of the `-S` flag:

```bash
git commit -S -m "My commit msg"
```

You can tell Git to always sign commits without your needing to explicitly include the `-S` flag:
```bash
git config --global commit.gpgsign true
```

> Signing commits by-default may be a good idea if you're working for an organization that requires verified commits as part of their security policy.

You can test whether `gpg2` itself is working by running the command below:

```bash
echo "test" | gpg2 --clearsign
```


**Troubleshooting:** If you get the error message `Inappropriate ioctl for device` when trying to sign a git commit, run `export GPG_TTY=$(tty)` and try again. If running this command solves the problem and you're able to sign the commit successfully, then you'll need to add `export GPG_TTY=$(tty)` as a command that runs on WSL session startup. Do this by running `nano ~/.profile` to launch the Nano text editor and then add `export GPG_TTY=$(tty)` to the bottom of the file. Save when prompted and exit Nano.

Alternatively, you can use Windows Terminal instead of the Windows Command Prompt. Doing so solves the `Inappropriate ioctl for device` problem without requiring the above changes to `.profile`.
