FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:$PATH"
ENV NVM_DIR="/root/.nvm"
ENV TERM=xterm-256color

# Set working directory early
WORKDIR /root/workspace

# Install essentials and clean up
RUN apt update && \
    apt install -y --no-install-recommends \
        curl \
        wget \
        unzip \
        ripgrep \
        fd-find \
        openssh-client \
        git \
        pipx \
        python3-venv \
        python3-pip \
        luarocks \
        sudo \
        podman \
        apt-transport-https \
        gnupg \
        lsb-release \
        build-essential && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Ensure pipx is ready
RUN pipx ensurepath

# Install Python tools
RUN pipx install pyright uv

# Install NVM and Node.js LTS
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && nvm install --lts && nvm use --lts

# Install lazygit
RUN LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    rm lazygit lazygit.tar.gz

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install kubectl (latest stable)
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install k9s
RUN K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" && \
    tar -xzf k9s.tar.gz k9s && \
    mv k9s /usr/local/bin/k9s && \
    rm k9s.tar.gz

# Install Neovim (latest release) from GitHub
RUN NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -LO https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz && \
    tar -xzf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64 /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

# Set up the root user's environment
COPY .bashrc /root/.bashrc

