## 📒**프로젝트 소개 (one Command Provisioning)**

One Command(vagrant up)을 사용하여 Provisioning, Shell Script,yml를 이용하여 각각의 VM머신들을 Kubernetes 클러스터 구축,Monitering,service deploy를 자동화해주는  Infra 구축 서비스입니다.

(제작 기간: 📆 2023.01.17~2023.01.29)





## ** Notion link **
[Notion](https://occipital-dance-e20.notion.site/One-Command-Provisioning-Kubernetes-Proejct-f980fecbc52f4883bfa7442390f5bdf7)




## **✍️ 자동화 구현 목록**

- provisioning
- kubernetes clustering
- NFS
- Flutter_Web service deploy,
- Mapi api server service deploy
- Kubernetes Dashboard
- MetalLB





## 각 노드 설치 항목
Master Node(Control Plane) - ubuntu1804-gui-minimal
- Kube_env.sh - Kubernetes 환경설정 설치 shellscript
- Kube_master.sh - Kubernetes Cluster 구축 Init shellscript
- NFS_server.sh - NFS server를 만들기 위한 설치 shellscript
- Calico.sh - Kubernetes cluster network를 사용하기 위한 Calico설치 shellscript
- MetalLb.sh - external-ip를 사용하기위한 Metallb설치 shellscript
- FireFox.sh - web browser인 firefox를 설치 shellscript
- Dashboard.sh - Kubernetes dashboard 환경설정, Dashboard 접근 계정설정,Token을 생성 하기위해 사용하는 shellscript
- Dashboard.yml - Dashboard를 NodePort로 접근할수 있게 하는 Service deploy yml
- Mapi.yml - DatabaseServer를 Kubernetes Service로 deploy하기 위한 yml
- Flutter_web.yml - FlutterWeb을 Kubernetes Service로 deploy하기 위한 yml
- Storageclass.yml - NFS provider를 이용한 StorageClass service를 deploy하기 위한 yml








Worker Node - ubuntu1804
- Kube_env.sh - Kubernetes 환경설정 설치 shellscript
- Kube_work.sh - Kubernetes Cluster로 join 하기위한 shellscript
- NFS_client.sh - NFS_server와 mount하여 사용하기 위한 설치 shellscript












## **🛠 사용 기술**


### **Front-End**

- Web
    - **Language** : Dart
    - **Framework** :  ****Flutter
    - **Library :** provider,font_awesome,bubble,flutter_tts,http
    - **Deploy** : Docker
    - **Image**: wlwhs5014/flutter_web:0.0.5

### **Back-End**

- DB Server
    
    Mapi를 활용한 Restful API 서버
    
    - **Language** : javascript
    - **IDE** : VS Code,Node js
    - **Framework** : Mapi
    - **Database** :Firebase(Firestore)
    - **Deploy**: Docker
    - **Image :** wlwhs5014/mapi:0.0.2

### System

- Kubernetes
    - **CNI** : calico
    - **Load Balancer** : metalLB
- Vagrant
- Virtual Box

**Monitoring**

- Kubernetes-Dashboard
- Prometheus
    
    kubernetes cluster 메트릭 수집 도구
    
    - kube-state-metrics
    - node-exporter
- Grafana
    - Prometheus 로 수집한 자료 시각화 도구









## Web Server - Flutter_web

- 영어단어장 Web
- Web 서비스는 Wiki를 통해 확인하실 수 있습니다.

[Wiki](https://www.notion.so/Wiki-460e014cf91c40bab78f458c04719a9c)

## DataBase Server - Mapi

## **✍️** Mapi란?

- git page - https://github.com/dev-whoan/mapi

**MAP Data Structure Based API Express(Nodejs, javascript) Web Server based on MAP입니다.**

MongoDB,Mysql,Firestore과 연동하여 DBserver를 구축 할수있습니다.

- Mapi 특징
1. HTTP Request에 따른 DML사용 가능

  (GET→SELECT),(POST→ADD),(PUT→INSERT),(DELETE→DELETE)

1. Jwt token을 활용한 User authorization기능


