# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

# Install the ca-certificates package to update CA certificates
RUN apt-get update && apt-get install -y \
    ca-certificates

# Update CA certificates
RUN update-ca-certificates

# Add a command to select a mirror based on a condition
ARG USE_MIRROR=false
ENV use_mirror=$USE_MIRROR
RUN if [ "$use_mirror" = "true" ]; then \
    sed -i 's@http://archive.ubuntu.com/ubuntu/@https://mirrors.tuna.tsinghua.edu.cn/ubuntu/@' /etc/apt/sources.list \
    ;fi

# Update packages and install necessary software
RUN apt-get update \
    && apt-get install -y \
    curl \
    git \
    golang-go \
    unzip \
    make \
    gcc \
    g++ \
    clang \
    zoxide \
    ripgrep \
    fd-find \
    yarn \
    lldb \
    locales \
    pkg-config \
    libtool-bin \
    python3-pip \
    python3-venv \
    wget \
    libtree-sitter-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8


# Install python provider
RUN pip3 install neovim

# Set GOPROXY
RUN go env -w GOPROXY=https://goproxy.io,direct

WORKDIR /tmp

RUN git clone https://github.com/neovim/libtermkey.git && \
    cd libtermkey && \
    make && \
    make install && \
    cd ../ && rm -rf libtermkey

RUN git clone https://github.com/neovim/libvterm.git && \
    cd libvterm && \
    make && \
    make install && \
    cd ../ && rm -rf libvterm

RUN git clone https://github.com/neovim/unibilium.git && \
    cd unibilium && \
    autoreconf -fi && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd ../ && rm -rf unibilium

# Install the latest stable neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz \
    && tar xzf nvim-linux64.tar.gz -C /opt \
    && rm nvim-linux64.tar.gz
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Install the latest lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && mv lazygit /usr/local/bin \
    && rm lazygit.tar.gz

# Install nvm and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
ENV NODE_VERSION=18.18.2
RUN /bin/bash -c "source $HOME/.nvm/nvm.sh && nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && nvm use ${NODE_VERSION}"
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin:${PATH}"

# Install rust toolchain and tree-sitter-cli
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install tree-sitter-cli

# Install nvimdots
RUN curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh > /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

# Set the working directory inside the container
WORKDIR /root

# Set TERM
ENV TERM=xterm-256color

# Bootstrap
RUN nvim --headless "+Lazy! sync" +qa

# Start with bash for the convenience of new changes
CMD ["bash"]
