#!/bin/bash

sudo apt update && sudo apt dist-upgrade -y

sudo apt install -y \
openjdk-8-jdk-headless \
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
make 

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g npm

wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-3.0 -y
rm -f packages-microsoft-prod.deb
dotnet --version

echo "export DOTNET_CLI_TELEMETRY_OPTOUT=true" >> ~/.profile
echo "export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true" >> ~/.profile
echo "export DOCKER_HOST=tcp://0.0.0.0:2375" >> ~/.profile

echo "fs.inotify.max_user_watches=10000000" | sudo tee -a /etc/sysctl.conf

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

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

sudo usermod -aG docker $USER