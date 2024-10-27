#!/bin/bash
#
# Launches n instances of Stable Diffusion web UI
#
# Requires:
# - A security group with inbound TCP access on port 7860
# - An access key (this could be removed if no SSH access is required for debugging)
# - The user data file userdata.sh
# - Configuring the varibles below this header
#
# The instances make use of the "Amazon Linux 2 AMI with NVIDIA TESLA GPU Driver" AMI (ami-0b1fb9933c34dc708) to have working NVIDIA drivers.
# Also, by default g4dn.xlarge instances are used, but you can use a better GPU instance if you are willing to pay for it.
#
# Arguments:
#   -n: number of instances to create (default 1)

KEY_NAME="Name of the key for accessing your instances"
SECURITY_GROUP_NAME="ID of the security group stated in the requirements"

ninstances="1"
while getopts n: flag
do
    case "${flag}" in
        n) ninstances=${OPTARG};;
    esac
done

aws ec2 run-instances --image-id ami-0b1fb9933c34dc708 --count "${ninstances}" --instance-type g4dn.xlarge --key-name "${KEY_NAME}" --security-group-ids "${SECURITY_GROUP_NAME}" --user-data file://userdata.sh
