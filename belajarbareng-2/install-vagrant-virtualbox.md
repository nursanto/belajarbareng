## disable firewall and selinux
	systemctl disable firewalld ; systemctl stop firewalld
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
## update repository and install some packages
	yum -y update
	yum -y install vim tmux wget git
## add vbox repository and install some packages
	wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d/
	yum -y update
	yum -y install kernel-devel kernel-headers kernel-devel-3.10.0-1062.1.1.el7.x86_64 make patch gcc 
## reboot server for reload configuration
	reboot
## install virtual box and some packages
	yum -y install VirtualBox-5.2
	yum install -y  xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps firefox
	wget https://download.virtualbox.org/virtualbox/5.2.20/Oracle_VM_VirtualBox_Extension_Pack-5.2.20.vbox-extpack
	VBoxManage extpack install  Oracle_VM_VirtualBox_Extension_Pack-5.2.20.vbox-extpack
## install vagrant
	yum -y install https://releases.hashicorp.com/vagrant/2.2.0/vagrant_2.2.0_x86_64.rpm