# ibm-cloud-vpn2.0

### 1. Install podman

#### Mac OS:
~~~
brew update
brew install podman wget
podman machine init
podman machine start
~~~

#### RHEL:
~~~
yum install -y podman
~~~

### 2. Setting Environment Variables

~~~
export HOST=vpn.xxx.xxx.com
export USER='xxxx@xxx.com'
export PASSWD='xxxx'
export METHOD=radius
~~~

### 3. Build Dockerfile

~~~
./buildit.sh
~~~

### 4. Start VPNcontainer

~~~
./runit.sh 
~~~


### 5. Automatic Start VPN Container

#### RHEL:
~~~
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
~~~
~~~
systemctl enable VPNcontainer.service --now
~~~
~~~
crontab -e
~~~
~~~
# Restart the container to keep the VPN token valid.
*/5 * * * * /usr/bin/podman exec -it VPNcontainer /bin/bash -c 'ssh -o BatchMode=yes -t root@10.184.134.152 "exit"' > /dev/null 2>&1 || { systemctl restart VPNcontainer.service > /dev/null 2>&1; }
~~~

#### Mac OS:
~~~
crontab -e
~~~
~~~
# Restart the container to keep the VPN token valid.
*/5 * * * * /usr/local/bin/podman exec -it VPNcontainer /bin/bash -c 'ssh -o BatchMode=yes -t root@10.184.134.152 "exit"' > /dev/null 2>&1 || { /usr/local/bin/podman restart VPNcontainer > /dev/null 2>&1; }

# Check the status of the machine and container, and trigger the start if they are not started.
*/2 * * * * /usr/local/bin/podman machine list | grep -q 'Currently running' || /usr/local/bin/podman machine start && /usr/local/bin/podman ps --filter "name=VPNcontainer" --filter "status=running" | grep -q VPNcontainer || /usr/local/bin/podman restart VPNcontainer
~~~


### 6. Access Target environment
~~~
# Conatiner hosts:
export TARGET_IP=10.184.134.152
podman exec -it VPNcontainer /bin/bash -c 'ssh root@$TARGET_IP'

or

# PC to Container hosts:
export CONTAINER_HOST_IP=xxx
export TARGET_IP=xxx
ssh -t root@$CONTAINER_HOST-IP "podman exec -it VPNcontainer /bin/bash -c 'ssh -t root@$TARGET_IP'"
~~~


