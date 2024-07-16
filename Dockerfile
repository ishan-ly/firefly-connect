# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Install required system packages and dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    build-essential \
    software-properties-common \
    curl \
    snapd \
    openssl \
    bash \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Download the setup.sh script from the given URL
# RUN touch /app/setup.sh
# RUN curl -fsSL https://gist.githubusercontent.com/rohitroyrr8/6115f4295345203b7d443cab536ed6ab/raw/4f2cb341d91426ca7169f2ab1e696078b3305ce9/setup.sh | bash

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up the Docker repository
RUN ARCH=$(dpkg --print-architecture); \
    add-apt-repository "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker Engine
RUN apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Verify Docker and Docker Compose installations
RUN docker --version
RUN docker-compose --version

# Install Node.js
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
#     && apt-get install -y nodejs
#RUN nvm install 18

# Copy the application files
COPY . /usr/src/app

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

RUN node --version \
    && npm --version 

# Install Node.js dependencies
RUN npm install

# Build the Node.js application
RUN npm run build

# Download and install FireFly CLI
RUN wget "https://github.com/hyperledger/firefly-cli/releases/download/v1.3.0/firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz" && \
    tar -zxf "firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz" -C /usr/local/bin ff && \
    rm "firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz"

# Verify FireFly installation
RUN ff version

# Create a directory for FireFly initialization
RUN mkdir /usr/src/app/firefly-config

# Add your EVM connector config file to the container
COPY evmconnect.yml /usr/src/app/firefly-config/

# Initialize FireFly (if needed)
RUN ff init ethereum polygon 1 \
    --multiparty=false \
    --ipfs-mode public \
    -n remote-rpc \
    --remote-node-url https://polygon-amoy.g.alchemy.com/v2/1i-JadBalM7Dp1PnYL76aG1vREB_yfGp \
    --chain-id 80002 \
    --connector-config /usr/src/app/firefly-config/evmconnect.yml

# Expose the port for the Node.js application
EXPOSE 3000

# Start the Node.js application (replace with your startup command)
CMD ["sh", "-c", "dockerd & sleep 10 && ff start polygon && node /usr/src/app/dist/app.js"]
