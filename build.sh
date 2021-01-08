#!/bin/bash
# Build Control Plane Node VMs

set -x 
CLOUD_IMAGE=/home/vm-images
LOCAL_IMAGES=/var/lib/libvirt/images

for VM_NAME in cp-1 cp-2 cp-3
do 
virsh destroy $VM_NAME
sleep 2
virsh undefine $VM_NAME
cp -v $CLOUD_IMAGE/CentOS-7-x86_64-GenericCloud-2009.qcow2 $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2
qemu-img resize $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2 20GB
cloud-localds $LOCAL_IMAGES/rhel7config-$VM_NAME.iso $VM_NAME/user-data $VM_NAME/meta-data
sleep 4 
virt-install --memory 2048 \
--vcpus 2 \
--name $VM_NAME \
--disk $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2,device=disk \
--disk $LOCAL_IMAGES/rhel7config-$VM_NAME.iso,device=cdrom \
--os-type Linux \
--os-variant centos7.0 \
--virt-type kvm \
--graphics none \
--noautoconsole \
--import

echo "Finished building Control Plane VM: " $VM_NAME
done

unset VM_NAME

# Build Worker Node VMs
for VM_NAME in w-1 w-2 w-3
do
virsh destroy $VM_NAME
sleep 2
virsh undefine $VM_NAME
cp -v $CLOUD_IMAGE/CentOS-7-x86_64-GenericCloud-2009.qcow2 $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2
qemu-img resize $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2 20GB
cloud-localds $LOCAL_IMAGES/rhel7config-$VM_NAME.iso $VM_NAME/user-data $VM_NAME/meta-data
sleep 4
virt-install --memory 1024 \
--vcpus 1 \
--name $VM_NAME \
--disk $LOCAL_IMAGES/CentOS-7-x86_64-GenericCloud-2009.$VM_NAME.qcow2,device=disk \
--disk $LOCAL_IMAGES/rhel7config-$VM_NAME.iso,device=cdrom \
--os-type Linux \
--os-variant centos7.0 \
--virt-type kvm \
--graphics none \
--noautoconsole \
--import

echo "Finished building Worker VM: " $VM_NAME
done
