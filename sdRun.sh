#!/bin/bash

image=$1
kernel=$2
init=$3
qemu-system-aarch64 -m 1024 -boot order=ncd -machine virt,accel=tcg \
  -cpu cortex-a53 -kernel $kernel \
  -append "root=/dev/vda2 mem=1024M devtmpfs.mount=0 rw vga=normal" \
  -name SD-card_emulation_run -drive file=$image,if=sd,cache=writeback,id=hd-root \
  -net nic,macaddr=00:16:3e:00:00:01 -net user,hostfwd=tcp::2223-:22 \
  -netdev user,id=user.0 -device virtio-net-device,netdev=user.0 \
  -initrd $init \
  -device virtio-blk-device,drive=hd-root \
  -monitor stdio
