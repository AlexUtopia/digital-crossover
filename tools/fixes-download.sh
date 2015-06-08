#!/bin/bash
#${1} - Nuttx version
#${2} - Fixes download directory path


# Local variables
LOCAL_NUTTX_VERSION_LAST=7.8


LOCAL_NUTTX_VERSION=
if [ -z ${1} ]
then
    LOCAL_NUTTX_VERSION=${LOCAL_NUTTX_VERSION_LAST}
else
    LOCAL_NUTTX_VERSION=${1}
fi

LOCAL_FIXES_DIR=
if [ -z ${2} ]
then
    LOCAL_FIXES_DIR=./
else
    LOCAL_FIXES_DIR=${2}
fi

case ${LOCAL_NUTTX_VERSION} in
    "7.5" )
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-sama5d4-emac1.patch    -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-wdcreate.patch         -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-libelf.patch           -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-clocksystimer64.patch  -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-vfork.patch            -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-stm32f4discovery.patch -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.5/nuttx-7.5-mmkconfig.patch        -P ${LOCAL_FIXES_DIR}/
        ;;
    "7.6" )
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.6/nuttx-7.6-strncpy.patch          -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.6/nuttx-7.6-nomountpoint.patch     -P ${LOCAL_FIXES_DIR}/
        ;;
    "7.7" )
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-route.patch            -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-apr-noints.patch       -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-debug.patch            -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-wrbuffer-alloc.patch   -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-net-noints.patch       -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-recvfrom.patch         -P ${LOCAL_FIXES_DIR}/
        wget http://sourceforge.net/projects/nuttx/files/nuttx/nuttx-7.7/nuttx-7.7-workqueue.patch        -P ${LOCAL_FIXES_DIR}/
        ;;
     "7.8" )
        echo "Nuttx version ${LOCAL_NUTTX_VERSION} no available fixes"
        ;;
    *)
        echo "Nuttx version unknown : ${LOCAL_NUTTX_VERSION}"
        ;;
esac

