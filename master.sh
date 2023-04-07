
# 가상메모리 사용하지 않도록 설정 (모든 노드에)
#sudo swapoff /swap.img
sudo swapoff -a
sudo sed -i -e '/swap.img/d' /etc/fstab
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo ----Docker install ------
# docker를 CRI(Container Runtime Interface)로 사용하기 위해 docker를 설치 (모든 노드에)
curl -fsSL https://get.docker.com -o get-docker.sh
sleep 1
sudo sh get-docker.sh

echo -----Docker install Complete ------
#sudo sh get-docker.sh
systemctl restart docker
systemctl enable docker

# docker를 CRI(Container Runtime Interface)로 사용하기 위해 docker를 설치
# (현재 k8s는 공식적으로 docker를 지원하지 않기때문에 cri-dockerd 설치가 필요.)
# 1.14 미만의 k8s를 설치하는 것도 한가지 방법이다.


echo ---CRI  install------
git clone https://github.com/Mirantis/cri-dockerd.git
sleep 7
wget https://storage.googleapis.com/golang/getgo/installer_linux
sleep 3
chmod +x ./installer_linux
./installer_linux 
sleep 30

if [ -f "$HOME/.bash_profile" ]; then
  echo $HOME/.bash_profile
  cat $HOME/.bash_profile
  echo "bash_start"  
  . $HOME/.bash_profile
  echo "bash_complete"
  sleep 2
else
  echo "No .bash_profile Found under $HOME"
fi

cd cri-dockerd
sleep 3
mkdir bin
echo "build start"
go build -o bin/cri-dockerd

echo "build complete?"
sleep 10
# 이게오래걸림
mkdir -p /usr/local/bin
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sleep 20
cp -a packaging/systemd/* /etc/systemd/system
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service

systemctl daemon-reload
sleep 5
systemctl enable cri-docker.service
sleep 3
systemctl enable --now cri-docker.socket
echo ===========docker cri enable =================
systemctl status cri-docker

sleep 3
sudo systemctl restart docker && sudo systemctl restart cri-docker

echo docker restart
sleep 3
sudo systemctl status cri-docker.socket --no-pager
echo --cri docker install complete-------


# Docker Cgroup 변경- 설치한 CRI dockerd 사용하도록
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
	"max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

echo ========restart docker and cri-docker =================
sudo systemctl restart docker && sudo systemctl restart cri-docker

sleep 10
# Kernel Forwarding , kube-proxy(= 파드의 통신, 오버레이 네트워크를 담당) 설정.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

# iptable(우분투의 방화벽)이 오버레이 네트워크의 트래픽을 수용하도록 설정.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo apt-get update
sleep 20

# iptable이 오버레이 네트워크의 트래픽을 허용하도록 설정.

sudo apt-get install -y apt-transport-https ca-certificates curl
echo ----- iptable overlay setting ----------------------
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
ehcho ---kubeadm kubelet install
sleep 5
sudo apt-get install -y kubelet kubeadm kubectl
sleep 20
kubectl version --short
# 버전 확인 Kustomize Version: v4.5.7이면 된다.

echo ---version fix-------------------
sudo apt-mark hold kubelet kubeadm kubectl
# 해당 버전으로 고정

echo 'alias k=kubectl' >> ~/.bashrc
echo "alias ka='kubectl apply -f'" >> ~/.bashrc
echo "alias kd='kubectl delete -f'" >> ~/.bashrc



sudo kubeadm config images pull --cri-socket unix:///run/cri-dockerd.sock

sleep 15
echo ------kubenetes init------------
sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 --pod-network-cidr=10.10.0.0/16 --apiserver-advertise-address=211.183.5.120 --cri-socket /var/run/cri-dockerd.sock
# ip설정주의!!

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config