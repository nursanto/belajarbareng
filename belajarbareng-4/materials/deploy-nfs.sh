yum -y -q install nfs-utils > /dev/null 2&>1
mkdir -p /srv/nfs/kubedata
chmod -R 777 /srv/nfs/
cat >>/etc/exports<<EOF
/srv/nfs/kubedata       *(rw,sync,no_subtree_check,insecure)
EOF
systemctl start rpcbind nfs-server 
systemctl enable rpcbind nfs-server >/dev/null 2>&1
exportfs -v >/dev/null 2>&1
showmount -e
