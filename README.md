# ibm-cloud-vpn2.0


### Setting Environment Variables

```
export HOST=vpn.xxx.xxx.com
export USER='xxxx@xxx.com'
export PASSWD='xxxx'
export METHOD=radius
```

### build

```
./buildit.sh
```

### usage

```
./runit.sh 
```

### Automatic Start VPN Container
```
cat << EOF > /etc/systemd/system/VPNcontainer.service
[Unit]
Description= VPNcontainer
After=network.target
After=network-online.target
[Service]
Restart=always
ExecStart=/usr/bin/podman start -a VPNcontainer
ExecStop=/usr/bin/podman stop -t 10 VPNcontainer
[Install]
WantedBy=multi-user.target
EOF

systemctl enable VPNcontainer.service --now
```

4. Access Target environment
~~~
# Conatiner hosts:
export TARGET-IP=xxx
podman exec -it VPNcontainer /bin/bash -c 'ssh root@$TARGET-IP'

or

#Other:
export CONTAINER_HOST-IP=xxx
export TARGET-IP=xxx
ssh -t root@$CONTAINER_HOST-IP "podman exec -it VPNcontainer /bin/bash -c 'ssh -t root@$TARGET-IP'"
~~~


