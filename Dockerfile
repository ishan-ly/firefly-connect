# 0. Normal dockerfile
# 1. clone firefly repo // run firefly docker images
# 2. firefly init
# 3. 

# Stage 1: Build the Node.js application
FROM node:alpine as build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY ./package.json /app/

# Install dependencies
RUN npm install

# Copy everything to /app directory
COPY . /app

# Build the app
RUN npm run build

# Stage 2: Set up the final container
FROM alpine:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Install required system packages
RUN apk add --no-cache \
git \
build-base \
curl \
bash 

# Install Docker
RUN apk add --no-cache docker

RUN docker --version


# https://github.com/docker/compose/releases/download/v2.28.0/docker-compose-linux-x86_64
# Install Docker Compose
# Example Dockerfile using pre-built Docker Compose image
# FROM docker/compose:1.29.2
RUN wget https://github.com/docker/compose/releases/download/v2.28.0/docker-compose-linux-x86_64 -O /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN docker-compose --version

# Download and install FireFly CLI
RUN wget https://github.com/hyperledger/firefly-cli/releases/download/v1.3.0/firefly-cli_1.3.0_Linux_x86_64.tar.gz && \
    tar -zxf firefly-cli_1.3.0_Linux_x86_64.tar.gz -C /usr/local/bin ff && \
    rm firefly-cli_1.3.0_Linux_x86_64.tar.gz

# Verify FireFly installation
RUN ff version

# Copy the built Node.js application from the previous stage
COPY --from=build /app /usr/src/app

# Create a directory for FireFly initialization
RUN mkdir /usr/src/app/firefly-config

# Add your EVM connector config file to the container
COPY evmconnect.yml /usr/src/app/firefly-config/

# Initialize FireFly
RUN ff init ethereum polygon 1 \
    --multiparty=false \
    -n remote-rpc \
    --remote-node-url https://polygon-amoy.g.alchemy.com/v2/1i-JadBalM7Dp1PnYL76aG1vREB_yfGp \
    --chain-id 80002 \
    --connector-config /usr/src/app/firefly-config/evmconnect.yml \
    --verbose

# Expose the port for the Node.js application
EXPOSE 3000

# Define environment variable

# Start both FireFly and the Node.js application
CMD ["sh", "-c", "ff start polygon && node /usr/src/app/dist/app.js"]
