#!/bin/bash

useradd ${k8s_user}
usermod --password ${k8s_pass} ${k8s_user}
sed -i "s/#PasswordAuthentication/PasswordAuthentication/ig" ./test
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/ig" ./test
systemctl restart sshd

while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
  echo "Waiting for APT..."
  sleep 5
done
apt-get install -y git

git clone https://github.com/cybrkit/k8s.git
sed
bash init &