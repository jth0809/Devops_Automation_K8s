KUBERNETES_VERSION=v1.29
PROJECT_PATH=prerelease:/main
echo "Update Linux"
sudo apt-get -qq update

echo "install helm"
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get -qq update
sudo apt-get -y install helm

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

echo "install cri-o podman kubelet kubeadm kubectl"
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update
sudo apt-get install -y cri-o podman kubelet kubeadm kubectl 
sudo apt-mark hold cri-o podman kubelet kubeadm kubectl


echo "restarting services"
sudo systemctl daemon-reload
sudo systemctl start crio.service
sudo systemctl restart kubelet
sudo swapoff -a
sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1

echo "starting kubeadm"
kubeadm init

echo "install jenkins on k8s"
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins


