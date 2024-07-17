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

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up the Docker repository
RUN ARCH=$(dpkg --print-architecture); \
    add-apt-repository "deb [arch=${ARCH}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker Engine
RUN apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Verify Docker and Docker Compose installations
RUN docker --version
RUN docker-compose --version

# Copy the application files
COPY . /usr/src/app

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Verify Node installation
RUN node --version \
    && npm --version 

# Copy .env
RUN cp .env.example .env

# Install Node.js dependencies
RUN npm install

# Install PM2 globally
RUN npm install -g pm2 pm2-runtime

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

#SET Arguments
ARG RPC_URL=https://polygon-amoy.g.alchemy.com/v2/1i-JadBalM7Dp1PnYL76aG1vREB_yfGp
ARG STACK_NAME=polygon

# Set environment variable from build argument
ENV RPC_URL=${RPC_URL}
ENV STACK_NAME=${STACK_NAME}

# Initialize FireFly (if needed)
RUN ff init ethereum ${STACK_NAME} 1 \
    --multiparty=false \
    --ipfs-mode public \
    -n remote-rpc \
    --remote-node-url ${RPC_URL}  \
    --chain-id 80002 \
    --connector-config /usr/src/app/firefly-config/evmconnect.yml

# Expose the port for the Node.js application
EXPOSE 3000 5000 5109

# Start the Node.js application (replace with your startup command)
CMD ["sh", "-c", "dockerd & sleep 10 && ff start ${STACK_NAME} && pm2-runtime start /usr/src/app/dist/app.js --name fireflyapp"]
