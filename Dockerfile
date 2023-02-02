FROM rocker/rstudio:4.1.2

ARG USERNAME=shiny
ARG USER_UID=1001
ARG USER_GID=1000

ARG SCHEMATIC_VERSION=23.1.1
ARG PYTHON_VERSION=3.10.8
ARG PYTHON_MAJOR=3

LABEL schematic="v$SCHEMATIC_VERSION"
LABEL python="$PYTHON_VERSION"

# Create the user
RUN useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

WORKDIR /home/app

# install system packages, including ones needed for R pkgs and to build python
RUN sudo apt-get update && sudo apt-get install -y \
    gdebi-core \
    curl \
    libcurl4-openssl-dev \
    git \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    && sudo rm -rf /var/lib/apt/lists/*

# build python from source
RUN sudo curl -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz &&\
    sudo tar -xvzf Python-$PYTHON_VERSION.tgz &&\
    cd Python-$PYTHON_VERSION &&\
    sudo ./configure \
    --prefix=/opt/python/$PYTHON_VERSION \
    --enable-shared \
    --enable-optimizations \
    --enable-ipv6 \
    LDFLAGS=-Wl,-rpath=/opt/python/$PYTHON_VERSION/lib,--disable-new-dtags &&\
    sudo make &&\
    sudo make install &&\
    echo Installed /opt/python/$PYTHON_VERSION/bin/python$PYTHON_MAJOR --version

# install pip and clean up python build intermediates
RUN sudo curl -O https://bootstrap.pypa.io/get-pip.py &&\
    sudo /opt/python/$PYTHON_VERSION/bin/python$PYTHON_MAJOR get-pip.py &&\
    sudo rm -Rf Python-$PYTHON_VERSION Python-$PYTHON_VERSION.tgz get-pip.py

# set up app user/group, app assets
RUN sudo chown shiny:1000 -R /home/app

RUN /opt/python/$PYTHON_VERSION/bin/python$PYTHON_MAJOR -m venv .venv &&\
    . .venv/bin/activate && python3 -m pip install schematicpy==$SCHEMATIC_VERSION && \
    zip -r .venv.zip .venv && \
    sudo rm -rf .venv

# install R packages
COPY install-pkgs.R install-pkgs.R
RUN sudo R -f install-pkgs.R

COPY ./modules ./modules
COPY ./functions ./functions
COPY ./www ./www
COPY ./global.R ./global.R
COPY ./server.R ./server.R
COPY ./ui.R ./ui.R



