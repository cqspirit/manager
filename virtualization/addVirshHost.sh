virt-install \
--autostart \
--prompt \
-p  \
-n next-39 \
-r 12000 \
--vcpus=5 \
-l  http://mirror.nus.edu.sg/centos/6.3/os/x86_64/ \
--network bridge=br1 \
--nographics  \
--virt-type=xen \
-f /dev/vg_next-11/lv_public_vm5 \
--os-type=linux
 
