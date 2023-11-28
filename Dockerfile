FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"]

# Install dependencies
# xmllint used by the scripts
# need fuse to run neovim appimage
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    git \
    curl \
    wget \
    unzip \
    libxml2-utils \
    fuse \
    cmake \
    && rm -rf /var/lib/apt/lists/*

ADD . /setup
WORKDIR /setup
RUN ./install_nvim.sh
RUN ./install_node.sh
RUN ./install_clangd.sh
RUN ./install_go.sh
# add go to path
ENV PATH="/usr/local/go/bin:${PATH}"

# clone packer.nvim
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# clone neovim config
RUN git clone https://github.com/JudsenHembree/nvimConfig.git /root/.config/nvim

# install plugins
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
# install mason lsp
RUN nvim --headless -c "MasonInstall stylua" -c "qall"
RUN nvim --headless -c "MasonInstall pyright" -c "qall"
RUN nvim --headless -c "MasonInstall gopls" -c "qall"
RUN nvim --headless -c "MasonInstall typescript-language-server" -c "qall"
# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# add rust to path
ENV PATH="/root/.cargo/bin:${PATH}"
# install ripgrep
RUN cargo install ripgrep
