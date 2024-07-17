# Firefly Connect APIs

This repo contains source code for Hyperledger Firefly connect. 


## Features

- Deployment of any custom smart contracts
- Perform read and write operations on your deployed smart contracts
- Swagger UI integration to interact with APIs directly
- Access to the Firefly UI and snadbox

## Run Locally

Clone the project

```bash
  git clone https://github.com/loyyal/firefly-connect.git
```

Go to the project directory

```bash
  cd firefly-connect
```

Copy .env

```bash
  cp .env.example .env
```

Install docker

```bash
  apt-get install -y docker-ce docker-ce-cli containerd.io
```

Install docker compose

```bash
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
```

Install openssl

```bash
  apt-get install openssl
```

Install dependencies

```bash
  npm install
```

Download and install FireFly CLI

```bash
  wget "https://github.com/hyperledger/firefly-cli/releases/download/v1.3.0/firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz" && \
    tar -zxf "firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz" -C /usr/local/bin ff && \
    rm "firefly-cli_1.3.0_$(uname -s)_$(uname -m).tar.gz"

```

Copy evmconnect.yml

```bash
  cp evmconnect.yml ~/Desktop/evmconnect.yml
```
Initialize Firefly

```bash
  ff init ethereum polygon 1 \
    --multiparty=false \
    -n remote-rpc \
    --remote-node-url <selected RPC endpoint> \
    --chain-id 80002 \
    --connector-config ~/Desktop/evmconnect.yml
```

Start FireFly stack

```bash
  ff start polygon
```

Build

```bash
  npm run build
```

Start the server

```bash
  npm run start
```

## Deployment

Building docker image

```bash
aws ecr get-login-password --region me-south-1 | docker login --username AWS --password-stdin 827830277284.dkr.ecr.me-south-1.amazonaws.com

docker build -t 827830277284.dkr.ecr.me-south-1.amazonaws.com/firefly-connect:v1.0 . --build-arg RPC_URL=https://polygon-amoy.g.alchemy.com/v2/1i-JadBalM7Dp1PnYL76aG1vREB_yfGp --build-arg STACK_NAME=polygon --no-cache --progress=plain

docker push 827830277284.dkr.ecr.me-south-1.amazonaws.com/firefly-connect:v1.0

```

Running docker image 

```bash
  docker run -p 3000:3000 -p 5000:5000 -p 5109:5109 --privileged --name firefly-app 827830277284.dkr.ecr.me-south-1.amazonaws.com/firefly-connect:v1.0
```

## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`PORT`

## Appendix

- Run the command ```ff accounts list polygon ``` to list all the available wallets. Fund the default account with some MATIC.
- Web UI - http://localhost:5000/ui
- Sandbox UI - http://localhost:5109
- Swagger API UI - http://localhost:5000/api
