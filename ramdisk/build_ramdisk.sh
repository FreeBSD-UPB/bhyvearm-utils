
export ODIR=/root/obj/arm.armv6/root/bhyvearm/src

cp ${ODIR}/sys/FVP_VE_CORTEX_A15x1_GUEST/kernel.bin .

makefs -t ffs -B little\
	-o optimization=space\
	-o version=1\
	ramdisk.img ramdisk.mtree

makefs -t ffs -B little\
	-o optimization=space\
	-o version=1\
	ramdisk-guest.img ramdisk-guest.mtree

