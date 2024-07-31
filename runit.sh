#!/bin/bash
sudo podman run -d --name VPNcontainer --privileged ibm-cloud-vpn2.0 --method $METHOD --host $HOST --user $USER --passwd $PASSWD --loglevel warn
