# Use a stable Node.js image
FROM node:25-trixie

# Install git as it is often required for coding agents
RUN apt-get update \
    && apt-get install -y curl git python3 python-is-python3 tmux vim fd-find\
    && rm -rf /var/lib/apt/lists/*

RUN curl -LOk https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep_15.2.0-1_amd64.deb
RUN dpkg -i ripgrep_15.2.0-1_amd64.deb && rm ripgrep_15.2.0-1_amd64.deb

# Update npm
RUN npm install -g npm

# Install the pi coding agent globally
RUN curl -fsSLk https://pi.dev/install.sh | sh

# Set the working directory inside the container
WORKDIR /app

# Install ttyd for browser-based terminal access
RUN curl -fsSLk https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -o /usr/local/bin/ttyd && chmod +x /usr/local/bin/ttyd

EXPOSE 7681

# Copy startup script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Default: start ttyd (for service/browser mode)
# When run via `docker compose run`, CMD is overridden for interactive use
CMD ["/usr/local/bin/start.sh"]
