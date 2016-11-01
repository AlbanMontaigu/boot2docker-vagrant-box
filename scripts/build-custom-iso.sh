#!/bin/sh

# Shell execution configuration
set -x
set -e

# Env var configuration
MNT_TMP_DIR="/tmp/mnt"
EXTRACT_DIR="/tmp/extract"
NEW_ISO_DIR="/tmp/newiso"
SYSLINUX_DIR="/mnt/syslinux"
B2D_ISO_PATH="/tmp/boot2docker-orig.iso"
LOCAL_TCZ_PATH="/tmp/tcz"
NEW_B2D_ISO_PATH="/tmp/boot2docker-vagrant.iso"

# START AMU 20150625 : cheating to get boot2docker iso
curl -L -o "${B2D_ISO_PATH}" "${B2D_ISO_URL}"
# END AMU 20150625

# Prepare directories layout
rm -rf "${MNT_TMP_DIR}" "${EXTRACT_DIR}" "${NEW_ISO_DIR}" "${SYSLINUX_DIR}"
mkdir -p "${NEW_ISO_DIR}" "${EXTRACT_DIR}" "${MNT_TMP_DIR}" "${SYSLINUX_DIR}"

# Get tynicore linux tcz repo url (with failover url)
TCE_MIRROR_MAIN="http://tinycorelinux.net"
TCE_MIRROR_ALTERNATIVE="http://distro.ibiblio.org/tinycorelinux"
TCE_MIRROR=""
TCZ_VERSION="$(version | cut -d '.' -f 1).x"
TCZ_URL_SUFFIX="${TCZ_VERSION}/x86_64/tcz"
TCZ_URL=""
TCZ_URL_MAIN="${TCE_MIRROR_MAIN}/${TCZ_URL_SUFFIX}"
TCZ_URL_ALTERNATIVE="${TCE_MIRROR_ALTERNATIVE}/${TCZ_URL_SUFFIX}"
if curl --output /dev/null --silent --head --fail "${TCZ_URL_MAIN}/syslinux.tcz"; then
    TCE_MIRROR="${TCE_MIRROR_MAIN}"
    TCZ_URL="${TCZ_URL_MAIN}"
else
    TCE_MIRROR="${TCE_MIRROR_ALTERNATIVE}"
    echo "${TCE_MIRROR}" > /opt/tcemirror
    TCZ_URL="${TCZ_URL_ALTERNATIVE}"
fi

# Install some tools needed for building our ISO
# Note that even if the install worked, tce-load return exit code to 1...
su -c "tce-load -w -i mkisofs-tools" docker || :
su -c "tce-load -w -i compiletc" docker || :
su -c "tce-load -w -i autoconf" docker || :

# Note that due to 64 bits userspace in TCL, we have to get the syslinux from x86 one
curl -L -o "${LOCAL_TCZ_PATH}/syslinux.tcz" "${TCZ_URL}/syslinux.tcz"
mount "${LOCAL_TCZ_PATH}/syslinux.tcz" "${SYSLINUX_DIR}" -o loop,ro

# Extract the initrd.img (Linux root filesystem) from the iso
mount "${B2D_ISO_PATH}" "${MNT_TMP_DIR}" -o loop,ro
ls -al "${NEW_ISO_DIR}/"
cp -a "${MNT_TMP_DIR}/boot" "${NEW_ISO_DIR}/"
cp -a "${MNT_TMP_DIR}/version" "${NEW_ISO_DIR}/"
ls -al "${NEW_ISO_DIR}/"
umount "${MNT_TMP_DIR}"

# Unarchive the initrd.img to a Folder in $ROOTFS
# uncompress with xz and use cpio to transcript to files/dirs
# See https://github.com/boot2docker/boot2docker/blob/master/rootfs/make_iso.sh#L38
mv "${NEW_ISO_DIR}/boot/initrd.img" "${EXTRACT_DIR}/initrd.xz"
cd "${EXTRACT_DIR}"
/usr/local/bin/unxz -9 --format=lzma -d "${EXTRACT_DIR}/initrd.xz" --stdout | cpio -i -H newc -d
cd -
rm -f "${EXTRACT_DIR}/initrd.xz"

# Install our custom tcz
for TCZ_PACKAGE in popt attr acl rsync glibc_apps; do
    curl -L -o "${LOCAL_TCZ_PATH}/${TCZ_PACKAGE}.tcz" "${TCZ_URL}/${TCZ_PACKAGE}.tcz"; \
    echo "== debug 1"
    ls -l "${LOCAL_TCZ_PATH}/${TCZ_PACKAGE}.tcz"
    echo "== debug 2"
    ls -l "${MNT_TMP_DIR}"
    mount "${LOCAL_TCZ_PATH}/${TCZ_PACKAGE}.tcz" "${MNT_TMP_DIR}" -o loop,ro
    cd "${MNT_TMP_DIR}"
    cp -a ./* "${EXTRACT_DIR}/"
    cd -
    umount "${MNT_TMP_DIR}"
done

## Install our source-based applications
# Xorriso for creating bootable ISOs
# Last part will need to recompile ourself xorriso since syslinux (with isohybrid) nor xorriso exists as it in TCL in 64Bits
XORRISO_VERSION=1.4.6
curl -L -o "${LOCAL_TCZ_PATH}/xorriso-${XORRISO_VERSION}.tar.gz" "http://www.gnu.org/software/xorriso/xorriso-${XORRISO_VERSION}.tar.gz"
tar -x -z -f "${LOCAL_TCZ_PATH}/xorriso-${XORRISO_VERSION}.tar.gz" -C /tmp/
cd "/tmp/xorriso-${XORRISO_VERSION}"
./configure
make
make install
cd -

# Generate the new initrd.img in new iso dir
cd "${EXTRACT_DIR}"
find | cpio -o -H newc | /usr/local/bin/xz -9 --format=lzma > "${NEW_ISO_DIR}/boot/initrd.img"
cd -

# Create our new ISO in MBR-hybrid format with Xorriso
/usr/local/bin/xorriso  \
    -publisher "Alban MONTAIGU" \
    -as mkisofs \
    -l -J -R -V "Custom Boot2Docker-v$(cat ${NEW_ISO_DIR}/version)" \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
    -isohybrid-mbr /mnt/syslinux/usr/local/share/syslinux/isohdpfx.bin \
    -o "${NEW_B2D_ISO_PATH}" "${NEW_ISO_DIR}"

rm -rf "${MNT_TMP_DIR}" "${EXTRACT_DIR}" "${NEW_ISO_DIR}"