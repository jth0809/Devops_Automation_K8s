KUBERNETES_VERSION=v1.29
PROJECT_PATH=prerelease:/main
echo ' '
echo "Update Linux"
sudo apt-get -qq update

echo ' '
echo "install helm"
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get -qq update
sudo apt-get -y install helm

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1

echo ' '
echo "install cri-o podman kubelet kubeadm kubectl"
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update
sudo apt-get install -y cri-o podman kubelet kubeadm kubectl 
sudo apt-mark hold cri-o podman kubelet kubeadm kubectl

echo ' '
echo "restarting services"
sudo systemctl daemon-reload
sudo systemctl start crio.service
sudo systemctl restart kubelet

echo ' '
echo "starting kube"
sudo kubeadm init

echo ' '
echo "add helm repos"
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo add argo https://argoproj.github.io/argo-helm


kubectl create namespace tigera-operator

helm repo update
helm install calico projectcalico/tigera-operator --version v3.27.0 --namespace tigera-operator
helm install argo argo/argo-cd

echo ' '
echo "create .kube"

export KUBECONFIG=/etc/kubernetes/admin.conf

sudo kubectl taint nodes --all node-role.kubernetes.io/control-plane-
sudo kubectl port-forward service/argo-argocd-server -n default 8080:443

