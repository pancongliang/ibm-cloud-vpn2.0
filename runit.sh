#!/bin/bash
    source <(grep = vpn.ini)
    printf "\n$method $host $user $log\n"
    
    sudo podman run -d --name VPNcontainer --privileged ibm-cloud-vpn2.0 --method $method --host $host --user $user --passwd $PASSWD --loglevel $log
