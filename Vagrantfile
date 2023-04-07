Vagrant.configure("2") do |config|
  
  config.vm.define "master" do |cfg|
    cfg.vm.box = "araulet/ubuntu1804-desktop-minimal"
    cfg.vm.provider "virtualbox" do |vb|
      vb.name = "masterss"
      vb.cpus = 2
      vb.memory = 3072
      vb.gui=true
    end
    cfg.vm.host_name = "master"
    cfg.vm.network "private_network", ip: "211.183.5.120"
    cfg.vm.provision "shell", path: "nfs_server.sh"
    cfg.vm.synced_folder "configs/", "/share"
    cfg.vm.provision "shell", path: "kube_master.sh"
    cfg.vm.provision "shell", path: "calico.sh"
    cfg.vm.provision "shell", path: "metallb.sh"
    cfg.vm.provision "shell", path: "firefox.sh"
    cfg.vm.provision "shell", inline: "kubectl apply -f  /share/flutter/web.yml"
    cfg.vm.provision "shell", inline: "kubectl apply -f  /share/flutter/web2.yml"
    cfg.vm.provision "shell", path: "dashboard.sh"
    cfg.vm.provision "shell", inline: "kubectl apply -f /share/dashboard/dash.yml"
    
  end
  config.vm.define "worker" do |cfg1|
    cfg1.vm.box = "generic/ubuntu1804"
    cfg1.vm.provider "virtualbox" do |vb|
      vb.name = "workss"
      vb.cpus = 2
      vb.memory = 3072
    end
    cfg1.vm.host_name = "worker"
    cfg1.vm.network "private_network", ip: "211.183.5.130"
    cfg1.vm.provision "shell", path: "nfs_client.sh"
    cfg1.vm.provision "shell", path: "kube_worker.sh"
    
  end
  config.vm.define "worker2" do |cfg2|
    cfg2.vm.box = "generic/ubuntu1804"
    cfg2.vm.provider "virtualbox" do |vb|
      vb.name = "work2"
      vb.cpus = 2
      vb.memory = 3072
    end
    cfg2.vm.host_name = "worker2"
    cfg2.vm.network "private_network", ip: "211.183.5.140"
    cfg2.vm.provision "shell", path: "nfs_client.sh"
    cfg2.vm.provision "shell", path: "kube_worker.sh"
    
  end
  




end