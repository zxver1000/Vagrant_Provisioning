echo "====dashboard====="

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF


cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
EOF

kubectl -n kubernetes-dashboard create token admin-user >> /share/dashboard/token.txt
cp /share/dashboard/token.txt /home/vagrant/token.txt
cp /share/dashboard/dashboard_address.txt /home/vagrant/address.txt
echo ==proxy=======
#sudo kubectl proxy &

