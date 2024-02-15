echo "Update Linux"
sudo apt-get -qq update

echo "install helm"
sudo apt-get -y install apt-transport-https ca-certificates curl
sudo curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get -qq update
sudo apt-get -y install helm

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

echo "install kubectl"
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -qq update
sudo apt-get -y install kubelet, kubeadm, kubectl

echo "install jenkins on k8s"
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins


