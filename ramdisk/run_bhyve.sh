#!/bin/sh

MEM_BASE=0x80000000

set -x

/network.sh

# Start virtual machine
kldload vmm
kldstat

if [ "$1" != "Linux" ]; then
    bhyveload                                               \
        -k kernel.bin                                       \
        test

    bhyve -b                                                \
        -s 0x200@0x4000#-1:virtio-rnd                       \
        -s 0x200@0x5000#22:virtio-console,sock=/test_sock   \
        -s 0x200@0x6000#23:virtio-net,tap0                  \
        -s 0x200@0x7000#24:virtio-blk,blk_disk              \
        test
else
    bhyveload                                               \
        -k kernel.bin                                       \
        -d +0x1000000                                       \
        -b ${MEM_BASE}                                      \
        -l $((${MEM_BASE} + 0x8000))                        \
        test

    bhyve -b                                                \
        -B ${MEM_BASE}                                      \
        -s 0x200@0x4000#-1:virtio-rnd                       \
        -s 0x200@0x500000#25:virtio-console,sock=/test_sock   \
        -s 0x200@0x6000#23:virtio-net,tap0                  \
        -s 0x200@0x7000#24:virtio-blk,blk_disk              \
        test
fi
