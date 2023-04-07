echo "=========start install nfs=============="
sudo apt update
sudo apt install -y nfs-kernel-server 
sleep 15

sudo mkdir -p /shared
cp -r /share/* /shared/
sudo chown -R nobody:nogroup /shared
sudo chmod 777 /shared
sudo echo "/shared *(rw,sync,no_subtree_check)" >> /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
echo "========end  nfs============"
