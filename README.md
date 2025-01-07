# Devops_Automation_K8s
Helm을 이용한 Gitops (Jenkins / ArgoCD) 구현
# 계획
https://github.com/jth0809/AWS_Free_Tier_Microservice  
위 프로젝트를 고가용성과 배포 자동화를 위해 Docker-Compose에서 쿠버네티스로 전환하고 이식할 수 있게 합니다.

Docker-Compose는 기본적으로 각 컨테이너의 오토스케일링 기능이 없으므로 단일 장애 점이 발생할 수 있습니다.

또 롤링 업데이트와 같은 무중단 업데이트가 기본적으로 없으므로 번거롭게 서비스를 업데이트해야 합니다.

이 때문에 쿠버네티스로 전환하여 고가용성과 배포 자동화를 달성하기 위해 이 프로젝트를 시작합니다.

주요기술: Kubernetes, Jenkins, ArgoCD
![구조도](img/Microservice.PNG)

# 실행방법
```bash
   git clone https://github.com/jth0809/Devops_Automation_K8s.git
   cd Devops_Automation_K8s
   cd <select-folder>
   helm install <name> ./
```

### 향후방향
ArgoCD 설정 자동화, Jenkins 잡 등록 자동화, 쿠버네티스 설치, 설정 자동화  

후보기술: Helm, Ansible

## 문제해결
Jenkins는 HTTP, Microservice에서는 HTTPS를 사용하기 때문에 Ingress에서 Jenkins와 Microservice 둘 중 하나는 접속이 불가능한 문제 

백엔드 프로토콜을 HTTP로 통일하고 Ingress에 HTTPS 인증서를 적용하는 방법으로 해결 (외부에서는 HTTPS 연결으로 인식)

Jenkins에이전트에서 Docker 명령어를 찾을 수 없다는 문제

Docker Socket 파일을 Jenkins 에이전트에 마운트 하고 Docker in Docker 컨테이너를 에이전트에 생성해 해결  
(Docker in Docker는 보안상 문제가 있을 수 있음)

# (구) 계획
jenkin, sonarqube, owasp zap, java services

vagrant 이용 node 확장

kubeadm init 시 auth 정보 저장

argocd portforward command 저장

## (구) Troubles

kubeadm join 시 token, ip 오류

token 재생성후 해결

`kubectl token create --print-join-command`

가상머신의 ip가 인터넷 연결을 위해 NAT와 호스트 네트워크로 설정되어있는데 기본설정된 NAT 네트워크로 쿠버네티스 클러스터가 생성되어 join 되지 않는 문제 발생 

ip 대역 / 네트워크 어댑터 설정 후 해결

`sudo kubeadm init --apiserver-advertise-address=xxx.xxx.xxx.xxx --pod-network-cidr=xxx.xxx.xxx.xxx/xx`

enp0s3 -> enp0s8
