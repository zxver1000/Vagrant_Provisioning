echo "=========nfs common install==========="
sudo apt update
sleep 20
sudo apt -y install nfs-common
sleep 10
sudo mkdir -p /share
sudo mount 211.183.5.120:/shared /share