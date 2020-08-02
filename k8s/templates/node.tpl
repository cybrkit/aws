#!/bin/bash

useradd ${k8s_user}
usermod --password ${k8s_pass} ${k8s_user}
sed -i "s/#PasswordAuthentication/PasswordAuthentication/ig" ./test
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/ig" ./test
systemctl restart sshd

