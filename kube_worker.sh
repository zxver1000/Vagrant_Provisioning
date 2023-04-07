
sudo swapoff -a
#sudo swapoff /swap.img
sudo sed -i -e '/swap.img/d' /etc/fstab

echo ----Docker install ------
curl -fsSL https://get.docker.com -o get-docker.sh
sleep 1
sudo sh get-docker.sh

echo -----Docker install Complete ------
systemctl restart docker
systemctl enable docker


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
sleep 3
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
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF


cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo apt-get update
sleep 20



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

echo ---version fix-------------------
sudo apt-mark hold kubelet kubeadm kubectl


# alias setting
echo "##### alias setting"########
echo 'alias k=kubectl' >> ~/.bashrc
echo "alias ka='kubectl apply -f'" >> ~/.bashrc
echo "alias kd='kubectl delete -f'" >> ~/.bashrc


#ip-> Master_Node의 ip적어야함! 조인할떄
kubeadm join --token 123456.1234567890123456 --discovery-token-unsafe-skip-ca-verification 211.183.5.120:6443 --cri-socket=unix:///run/cri-dockerd.sock