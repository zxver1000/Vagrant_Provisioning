curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O

sed -i -e 's?192.168.0.0/16?10.10.0.0/16?g' calico.yaml
kubectl apply -f calico.yaml