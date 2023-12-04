# Stable Diffusion WebUI Docker server

A dockerized version of the [Stable Diffusion web UI by AUTOMATIC1111](https://github.com/AUTOMATIC1111/stable-diffusion-webui), including some models that show its potential.

## Usage

Prerequisites:
* A machine with GPU
* [Docker](https://www.docker.com/)
* [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

Then run the following

`docker run --gpus all --rm -p 7860:7860 albarji/sd-webui`

and you will be able to access the Stable Diffusion web UI through a browser at the address `YOUR_MACHINE_IP_ADDRESS:7860`.

Note the server will accept connections from any IP.

## Deploying in AWS

If you want to launch this server in [Amazon Web Services](https://aws.amazon.com), do as follows

### Prerequisites

1. Create a security group with the following permissions
   * Inbound access, HTTP, TCP, port 80, source 0.0.0.0/0 (allow HTTP conections to server).
   * (optional) Inbound access, SSH, TCP, port 22, source 0.0.0.0/0 (allow SSH connection for debugging or installing additional models).
   * Outbound access, all traffic, all protocols, all ports, 0.0.0.0/0 (allow all access to the internet).

You can further restrict the origin IP addresses if you want tighter access control. By default anybody on the internet can access your server!

2. (Optional) Create an access key. Only necessary if you want to access the server through SSH.

### Deployment

TODO
