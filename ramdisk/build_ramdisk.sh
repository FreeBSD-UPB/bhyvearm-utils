#!/bin/sh

if [ "$1" == "Guest" ]; then
    makefs -t ffs -B little\
            -o optimization=space\
            -o version=1\
            ramdisk-guest.img ramdisk-guest.mtree
elif [ "$1" == "Host" ]; then
    for t in rsa ecdsa ed25519; do
        if [ ! -f "ssh_host_${t}_key" ]; then
            echo "Generating host ${t} key"
            ssh-keygen -t ${t} -N "" -f "ssh_host_${t}_key"
        fi
    done

    pwd_mkdb    -d . master.passwd  # generate pwd.db, spwd.db
    pwd_mkdb -p -d . master.passwd  # generate passwd

    if [ ! -f id_rsa_board ]; then
cat <<EOF
Please create a key pair to connect to the board via SSH
The pair must be named 'id_rsa_board' / 'id_rsa_board.pub
To use the pair, use 'ssh -i bhyvearm-utils/ramdisk/id_rsa_board root@<board_ip>

To connect, before installing the board, please run
'/path/to/FastModels/FastModelsPortofolio_11.2/ModelNetworking/add_adapter_64.sh'.
Ideally, the bridge will be named armbr0 and the tap interface will be named
ARM<username>, as the emulator config in 'bhyvearm-utils/FastModels/files/app.txt'
expects. Assign an IP to the bridge interface use 'ip a a 10.0.0.41/28 dev armbr0'.
This IP will be in the same network as the IP assigned to the interface in the
emulated host, 10.0.0.42/28, assigned when running 'run_bhyve.sh' in the host.

The setup will end for now
EOF
        exit 1
    fi

    makefs -t ffs -B little\
            -o optimization=space\
            -o version=2\
            ramdisk.img ramdisk${2}.mtree
    STATUS=$?
    if [ ${STATUS} != 0 ]; then
        echo "Failed to build host ramdisk"
        exit ${STATUS}
    fi
else
    echo "Usage: $0 <Guest|Host>"
    exit 1
fi
