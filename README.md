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

If you want to launch this server in [Amazon Web Services](https://aws.amazon.com), do as follows. But bear in mind that you will need to pay AWS for the instances you create!

### Prerequisites

1. Create a security group with the following permissions
   * Inbound access, HTTP, TCP, port 80, source 0.0.0.0/0 (allow HTTP conections to server).
   * (optional) Inbound access, SSH, TCP, port 22, source 0.0.0.0/0 (allow SSH connection for debugging or installing additional models).
   * Outbound access, all traffic, all protocols, all ports, 0.0.0.0/0 (allow all access to the internet).

You can further restrict the origin IP addresses if you want tighter access control. By default anybody on the internet could access your server!

2. Install [AWS CLI](https://aws.amazon.com/cli/) in your machine, configured with your AWS user. Alternatively, use [AWS Cloudshell](https://docs.aws.amazon.com/cloudshell/latest/userguide/welcome.html).

3. Your AWS user must have full EC2 permissions.

4. (Optional) Create an access key. Only necessary if you want to access the server through SSH.

### Deployment

1. Clone this project into your machine our your AWS Cloudhsell terminal.
2. Access the `aws` subfolder.
3. Configure the `launch.sh` script with the name of the security group and the access key you created in the prerequisites step.
4. Run `launch.sh` to deploy the server. It should be accesible on port `80` after a few minutes.

### Tear down

Don't forget to terminate all the instances you have created once you have finished using them. You can do this in the AWS EC2 dashboard. None of us want you get bankrupt on AWS bills.
