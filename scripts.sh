#!/bin/bash

# ------------------------------------
# Install updates:
# ------------------------------------
sudo apt update && sudo apt dist-upgrade -y


# ------------------------------------
# Install dev tools:
# ------------------------------------
sudo apt install -y \
openjdk-11-jdk-headless \
maven \
golang-go \
python3-minimal \
build-essential \
apt-transport-https \
ca-certificates \
curl \
software-properties-common \
apache2-utils \
awscli \
make \
gnupg2

# ------------------------------------
# Install NodeJS:
# ------------------------------------
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs


# ------------------------------------
# Install .NET Core and turn off .NET Core telemetry:
# ------------------------------------
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-3.1 dotnet-sdk-5.0 -y
rm -f packages-microsoft-prod.deb
dotnet --list-sdks

echo "export DOTNET_CLI_TELEMETRY_OPTOUT=true" >> ~/.profile
echo "export DOCKER_HOST=tcp://0.0.0.0:2375" >> ~/.profile

echo "fs.inotify.max_user_watches=10000000" | sudo tee -a /etc/sysctl.conf


# ------------------------------------
# Install Docker and Docker Compose:
# ------------------------------------
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# Running "sudo apt-key fingerprint 0EBFCD88" should display:

# pub   rsa4096 2017-02-22 [SCEA]
#       9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
# uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
# sub   rsa4096 2017-02-22 [S]

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
docker --version

sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo usermod -aG docker $USER


# ------------------------------------
# Install GitHub CLI tools:
# ------------------------------------
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install -y gh


# ------------------------------------
# Install Azure CLI tools:
# ------------------------------------

# Get packages needed for the install process:
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y

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
sudo apt-get install azure-cli -y


# ------------------------------------
# Install AWS CLI tools:
# ------------------------------------
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo ./aws/install