#!/bin/bash

# https://discourse.ubuntu.com/t/building-multipass-images-with-packer/12361
# https://cloudinit.readthedocs.io/en/latest/topics/examples.html

image=$1
password=$2

mkdir -p cloud-data

cat >cloud-data/$image-user-data <<EOF
#cloud-config
password: $password
chpasswd: { expire: False }
ssh_pwauth: True
EOF

instance_id=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
cat >cloud-data/$image-meta-data <<EOF
instance-id: i-$instance_id
EOF

cloud-localds -v cloud-data/$image.img cloud-data/$image-user-data cloud-data/$image-meta-data