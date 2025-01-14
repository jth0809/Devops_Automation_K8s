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

# 작업정보
## 작업기간
2024.12 - 2025.01(진행중)
## 작업인원
1명

## 사용기술
Kubernetes, Jenkins, ArgoCD, Docker, Linux

# 실행방법
microservice의 경우 AWS Cognito 환경변수 설정이 필요합니다.(ArgoCD에서 설정을 추천합니다.)

```bash
   git clone https://github.com/jth0809/Devops_Automation_K8s.git
   cd Devops_Automation_K8s
   cd <select-folder>
   helm install <name> ./
```

### 향후방향
ArgoCD 설정 자동화, Jenkins 잡 등록 자동화, 쿠버네티스 설치, 설정 자동화  

후보기술: Helm, Ansible
