firewall --disabled

install

lang en_US.UTF-8
keyboard us
timezone UTC

network --bootproto=dhcp
rootpw vagrant
authconfig --enableshadow --passalgo=sha512

selinux --disabled
bootloader --location=mbr --append="no_timer_check"
text
skipx

logging --level=info
zerombr
eula --agreed

clearpart --all --initlabel

part /boot --fstype=xfs --size=512
part pv.01 --size=1 --grow
volgroup vg_main pv.01
logvol  /  --vgname=vg_main  --size=8192  --name=lv_root --grow
logvol swap --name=lv_swap --vgname=vg_main --grow --size=1024 --maxsize=1024

auth  --useshadow  --enablemd5
firstboot --disabled
reboot

%packages --ignoremissing
@Base
@Core
# vagrant needs this to copy initial files via scp
openssh-clients
sudo
kernel-headers
kernel-devel
gcc
make
perl
curl
wget
ntp
nfs-utils
net-tools
unbound-libs
bzip2
-fprintd-pam
-intltool
-NetworkManager
-NetworkManager-tui
%end


%post
groupadd vagrant -g 1001
useradd vagrant -g vagrant -G wheel -u 1001
echo "vagrant" | passwd --stdin vagrant

sed -i s'/^.*requiretty/#Defaults requiretty/' /etc/sudoers
sed -i s'/SELINUX=enforcing/SELINUX=disabled'/g /etc/selinux/config
%end
