KUBE_VERSION=1.15.0
CNI_VERSION=0.7.5

force_unlock(){
  rm -f /var/lib/apt/lists/lock
  rm -f /var/lib/dpkg/lock-frontend
  rm -f /var/lib/dpkg/lock
}

force_unlock
apt-get update

force_unlock
apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

force_unlock
apt-get update

# Install tools to bootstrap kubernetes cluster
force_unlock
apt-get install -y kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=${CNI_VERSION}-00

# Pull component images from gcr
kubeadm config images pull

# Disable swap to let kubelet work properly
swapoff -a
