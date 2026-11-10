FROM alpine:latest

# Neovim itself, native plugin/parser build tools, Mason runtime dependencies,
# and common CLI tools used by this configuration.
RUN --mount=type=cache,target=/var/cache/apk \
    apk add --cache-dir /var/cache/apk \
      bash \
      build-base \
      ca-certificates \
      clang \
      clang-extra-tools \
      cmake \
      coreutils \
      curl \
      fd \
      findutils \
      fzf \
      git \
      jq \
      less \
      make \
      ninja \
      nodejs \
      npm \
      neovim \
      openssh-client \
      py3-pip \
      ripgrep \
      rust \
      cargo \
      sqlite \
      tar \
      unzip \
      wget \
      xz \
      zip \
      tree-sitter-cli

ENV EDITOR=nvim \
    VISUAL=nvim

WORKDIR /workspace

CMD ["nvim"]
