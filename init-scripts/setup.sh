#!/bin/sh

apt-get install -y docker.io
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

dd if=/dev/zero of=/swapfile count=2048 bs=1M
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

kubeadm init

sed -i 's/\/usr\/bin\/kubelet/\/usr\/bin\/kubelet --fail-swap-on=false /' /etc/systemd/system/10-kubeadm.conf
kubeadm reset

systemctl daemon-reload
systemctl restart kubelet

