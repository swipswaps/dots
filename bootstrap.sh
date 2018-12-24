#!/bin/bash
# TODO
# - PHP composer
# - Autoremove elementary os / ubuntu bloat?
# - Development PEM's for localhost
# - Automate Chromium settings? Ex. chrome://flags/#allow-insecure-localhost
# - Ensure py3 and Groovy (http://groovy-lang.org/install.html)
# - Py3 DS libs numpy scipy pandas matplotlib + jupyter nb https://jupyter.org/install 
# - mycli / pgcli / robomongo
# - python3-sphinx
# - percona toolkit (https://www.percona.com/doc/percona-toolkit/LATEST/installation.html)
# - symlink mux to /usr/bin/tmuxinator
# - local databases for etl? disabled in systemd by default.
# - Other missing stuff?...
set -e
set -x
APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

DOTS_ROOT_RELATIVE=`dirname "$0"`
DOTS_ROOT=`realpath ${DOTS_ROOT_RELATIVE}`
DOTS_HOME=`realpath ~`
DOTS_USER=`whoami`
DOTS_GROUP=`id -g -n ${DOTS_USER}`
DOTS_OPT="/opt/$DOTS_USER"
DOTS_UBUNTU_SPORK=`lsb_release -cs`
WGET_UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chrome/70.0.3538.67 Safari/537.36"

# Elementary OS Loki = Xenial, Juno = Xenial
if [ "$DOTS_UBUNTU_SPORK" = "loki" ]; then
    DOTS_UBUNTU_SPORK="xenial"
elif [ "$DOTS_UBUNTU_SPORK" = "juno" ]; then
    DOTS_UBUNTU_SPORK="bionic"
fi

echo "I am $DOTS_USER:$DOTS_GROUP"
echo "$DOTS_ROOT is my home"

echo "Bootstrapping .dots ..."
cd "$DOTS_ROOT"
git submodule init
git submodule update

ln -sf "$DOTS_ROOT/tmux.conf" "$DOTS_HOME/.tmux.conf"
ln -sf "$DOTS_ROOT/zshrc.zsh" "$DOTS_HOME/.zshrc"
ln -sf "$DOTS_ROOT/oh-my-zsh" "$DOTS_HOME/.oh-my-zsh"
ln -sf "$DOTS_ROOT/.gitignore_global" "$DOTS_HOME/.gitignore"
ln -sf "$DOTS_ROOT/.editorconfig" "$DOTS_HOME/.editorconfig"
ln -sf "$DOTS_ROOT/.wgetrc" "$DOTS_HOME/.wgetrc"

# Initial APT install
sudo apt install gparted samba build-essential

echo "Bootstrapping $DOTS_OPT ..."

sudo mkdir -p "$DOTS_OPT" && sudo chown ${DOTS_USER}:${DOTS_GROUP} "$DOTS_OPT"

cd ${DOTS_OPT}

# IntelliJ
wget --progress=bar:force --content-disposition \
    --user-agent="$WGET_UA" \
    "https://download.jetbrains.com/product?code=IIU&latest&distribution=linux"

tar -xvf ideaIU-*.tar.gz
rm ideaIU-*.tar.gz

# OpenJ9 Java 8
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://api.adoptopenjdk.net/v2/binary/releases/openjdk8?openjdk_impl=openj9&os=linux&arch=x64&release=latest&type=jdk&heap_size=large" \
    -O openj9_jdk8.tar.gz

tar -xvf openj9_jdk8.tar.gz
mv jdk8u*openj9* openj9_jdk8
rm openj9_jdk8.tar.gz

sudo update-alternatives --install "/usr/bin/java" "java" "$DOTS_OPT/openj9_jdk8/bin/java" 5000 || true
sudo update-alternatives --install "/usr/bin/javac" "javac" "$DOTS_OPT/openj9_jdk8/bin/javac" 5000 || true

# OpenJ9 Java 11
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://api.adoptopenjdk.net/v2/binary/releases/openjdk11?openjdk_impl=openj9&os=linux&arch=x64&release=latest&type=jdk&heap_size=large" \
    -O openj9_jdk11.tar.gz

tar -xvf openj9_jdk11.tar.gz
mv jdk-11* openj9_jdk11
rm openj9_jdk11.tar.gz

sudo update-alternatives --install "/usr/bin/java" "java" "$DOTS_OPT/openj9_jdk11/bin/java" 5001 || true
sudo update-alternatives --install "/usr/bin/javac" "javac" "$DOTS_OPT/openj9_jdk11/bin/javac" 5001 || true

# Maven
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://apache.rediris.es/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz" \
    -O maven.tar.gz

tar -xvf maven.tar.gz
rm maven.tar.gz

sudo update-alternatives --install "/usr/bin/mvn" "mvn" "$DOTS_OPT/apache-maven-3.6.0/bin/mvn" 5000 || true

# Gradle
sudo apt-get install unzip
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://downloads.gradle.org/distributions/gradle-5.0-bin.zip" \
    -O gradle.zip
unzip gradle.zip
rm gradle.zip
sudo update-alternatives --install "/usr/bin/gradle" "gradle" "$DOTS_OPT/gradle-5.0/bin/gradle" 5000 || true

# Telegram
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://telegram.org/dl/desktop/linux" \
    -O telegram.tar.xz
tar -xvf telegram.tar.xz
rm telegram.tar.xz

# NIM
NIM_VERSION="0.19.0"
wget --progress=bar:force --user-agent="$WGET_UA" "https://nim-lang.org/download/nim-$NIM_VERSION.tar.xz" -O nim.tar.xz
tar -xvf nim.tar.xz
rm nim.tar.xz
cd "$DOTS_OPT/nim-$NIM_VERSION/"
sh build.sh
bin/nim c koch
./koch tools

sudo update-alternatives --install "/usr/bin/nim" "nim" "$DOTS_OPT/nim-$NIM_VERSION/bin/nim" 5000
sudo update-alternatives --install "/usr/bin/nimble" "nimble" "$DOTS_OPT/nim-$NIM_VERSION/bin/nimble" 5000
sudo update-alternatives --install "/usr/bin/nimgrep" "nimgrep" "$DOTS_OPT/nim-$NIM_VERSION/bin/nimgrep" 5000
sudo update-alternatives --install "/usr/bin/nimpretty" "nimpretty" "$DOTS_OPT/nim-$NIM_VERSION/bin/nimpretty" 5000 
sudo update-alternatives --install "/usr/bin/nimsuggest" "nimsuggest" "$DOTS_OPT/nim-$NIM_VERSION/bin/nimsuggest" 5000

# Stuff
echo "Installing things..."

# APT keys
sudo apt-key adv --recv-key --keyserver hkp://keyserver.ubuntu.com:80 \
    `# Crystal` \
    09617FD37CC06B54 \
    `# NodeSource` \
    1655A0AB68576280 \
    `# Spotify` \
    A87FF9DF48BF1C90 \
    `# Slack` \
    7253C9C8BF6A7041 \
    C6ABDCF64DB9A0B2 \
    `# Docker` \
    8D81803C0EBFCD88 \
    `# Insomnia` \
    379CE192D401AB61 \
    `# Yarn` \
    1646B01B86E50310 \
    `# Oracle Virtualbox` \
    A2F683C52980AECF \
    `# Google Cloud auto-signing kubectl and cloud-sdk` \
    6A030B21BA07F4FB \
    3746C208A7317B0F \
    `# Heroku` \
    C927EBE00F1B0520 \
    `# MS/Azure` \
    EB3E94ADBE1229CF

# Crystal
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list

# Node 10.x
echo "deb https://deb.nodesource.com/node_10.x $DOTS_UBUNTU_SPORK main" | sudo tee /etc/apt/sources.list.d/nodesource_10.list

# Spotify :)
echo "deb http://repository.spotify.com stable non-free" | sudo tee "/etc/apt/sources.list.d/spotify.list"

# Slack. Distro is always debian/jessie.
echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee "/etc/apt/sources.list.d/slack.list"

# Docker
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $DOTS_UBUNTU_SPORK stable" | sudo tee "/etc/apt/sources.list.d/docker.list"

# Insomnia
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list

# Yarn
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Virtualbox
echo "deb https://download.virtualbox.org/virtualbox/debian $DOTS_UBUNTU_SPORK contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# Google Cloud SDK && Kubectl
CLOUD_SDK_REPO="cloud-sdk-$DOTS_UBUNTU_SPORK"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb https://packages.cloud.google.com/apt kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list # Not a typo.

# Heroku CLI
echo "deb https://cli-assets.heroku.com/apt ./" | sudo tee /etc/apt/sources.list.d/heroku.list

# Azure CLI
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $DOTS_UBUNTU_SPORK main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# APT all the stuff
sudo apt-get update
sudo apt-get install -y build-essential gcc g++ make zsh tmux tmuxinator ruby git git-extras openvpn php-cli meld nodejs yarn pssh \
    apt-transport-https ca-certificates curl software-properties-common docker-ce virtualbox-5.2 google-cloud-sdk heroku azure-cli kubectl \
    crystal chromium-browser slack-desktop insomnia revelation python-pip zenmap filezilla vlc gimp spotify-client \
    libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev #crystal extras

sudo gem install tmuxinator
#sudo ln -s /usr/local/bin/tmuxinator /usr/local/bin/mux

sudo pip install --upgrade pip
sudo pip install glances awscli

sudo npm install -g typescript

sudo usermod -aG docker ${DOTS_USER}

# Other tools
cd /tmp

# Vagrant
wget --progress=bar:force --user-agent="$WGET_UA" \
    "https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb" -O vagrant.deb
sudo dpkg -i vagrant.deb

# D
wget --progress=bar:force --user-agent="$WGET_UA" \
    "http://downloads.dlang.org/releases/2.x/2.083.1/dmd_2.083.1-0_amd64.deb" -O dmd.deb
sudo dpkg -i dmd.deb

# Heroku CLI
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

# Micro
echo "Setting up micro"
curl https://getmic.ro | bash
sudo mv ./micro /usr/bin/micro

# Rust toolchain
curl https://sh.rustup.rs -sSf | sh

# ZSH as login shell
echo "Changing login shell"
sudo chsh -s /usr/bin/zsh ${DOTS_USER}

# GIT configs
git config --global core.excludesfile ~/.gitignore
git config --global user.email "mrtreinis@gmail.com"
git config --global user.name "Matīss Treinis"
git config --global push.default current
