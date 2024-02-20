# Devops_Automation_K8s
Helm을 이용한 Gitops (Jenkins / ArgoCD) 구현

jenkin, sonarqube, owasp zap, java services

vagrant 이용 node 확장

kubeadm init 시 auth 정보 저장

argocd portforward command 저장

# Troubles

kubeadm join 시 token, ip 오류

token 재생성후 해결

`kubectl token create --print-join-command`

가상머신의 ip가 인터넷 연결을 위해 NAT와 호스트 네트워크로 설정되어있는데 기본설정된 NAT 네트워크로 쿠버네티스 클러스터가 생성되어 join 되지 않는 문제 발생 

ip 대역 / 네트워크 어댑터 설정 후 해결

`sudo kubeadm init --apiserver-advertise-address=xxx.xxx.xxx.xxx --pod-network-cidr=xxx.xxx.xxx.xxx/xx`

enp0s3 -> enp0s8