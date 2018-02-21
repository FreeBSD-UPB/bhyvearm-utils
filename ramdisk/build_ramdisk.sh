export PLATFORM=${1:-CUBIEBOARD2}
export ODIR=/root/freebsd-obj/arm.armv6/root/freebsd/

cp ${ODIR}/sys/FVP_VE_CORTEX_A15x1_GUEST/kernel.bin .

makefs -t ffs -B little\
	-o optimization=space\
	-o version=1\
	ramdisk-guest.img ramdisk-guest.mtree
STATUS=$?
if [ ${STATUS} != 0 ]; then
    echo "Failed to build guest ramdisk"
    exit ${STATUS}
fi

makefs -t ffs -B little\
	-o optimization=space\
	-o version=2\
	ramdisk.img ramdisk.mtree
STATUS=$?
if [ ${STATUS} != 0 ]; then
    echo "Failed to build host ramdisk"
    exit ${STATUS}
fi
