#!/usr/bin/make

#
# Include configure file
#

include make.conf


#
# Local variables
#

NUTTX_PATCH   = nuttx.patch
APPS_PATCH    = apps.patch
EXE_DIR       = exe
SRC_DIR       = src
TMP_DIR       = tmp
PATCH_DIR     = patch
FIXES_DIR     = fixes
BUILDROOT_DIR = misc/buildroot
NUTTX_DIR     = nuttx
APPS_DIR      = apps


# Get toolchain prefix from buildroot configure file
-include $(SRC_DIR)/$(BUILDROOT_DIR)/configs/$(CONFIG_TOOLCHAIN)
TOOLCHAIN_PREFIX = $(BR2_ARCH)-$(BR2_GNU_TARGET_SUFFIX)-


#
# Targets
#

.PHONY: all configure configure_update toolchain download setup patch clean rebuild distclean menuconfig boot_firmware


all:
	mkdir -p $(EXE_DIR)/
	cd $(SRC_DIR)/$(NUTTX_DIR)/; . ./setenv.sh; make CROSSDEV=$(TOOLCHAIN_PREFIX) pass2; \
	$(TOOLCHAIN_PREFIX)size    -d        nuttx > ../../$(EXE_DIR)/nuttx.info;            \
	$(TOOLCHAIN_PREFIX)objdump -D        nuttx > ../../$(EXE_DIR)/nuttx.disassembly;     \
	$(TOOLCHAIN_PREFIX)objdump -t        nuttx > ../../$(EXE_DIR)/nuttx.map;             \
	$(TOOLCHAIN_PREFIX)objcopy -O ihex   nuttx   ../../$(EXE_DIR)/nuttx.hex;             \
	$(TOOLCHAIN_PREFIX)objcopy -O binary nuttx   ../../$(EXE_DIR)/nuttx.bin
	cp -f $(SRC_DIR)/$(NUTTX_DIR)/nuttx $(EXE_DIR)/nuttx.elf


configure:
	cd $(SRC_DIR)/$(NUTTX_DIR)/tools; ./configure.sh $(CONFIG_BOARD)
	# Hack for AVR (copy avr-libc headers to nuttx headers)
	ln -sf /usr/lib/avr/include/avr $(SRC_DIR)/$(NUTTX_DIR)/include/


configure_update:
	cp -f $(SRC_DIR)/$(NUTTX_DIR)/.config $(SRC_DIR)/$(NUTTX_DIR)/configs/$(CONFIG_BOARD)/defconfig


toolchain: download configure
	cd $(SRC_DIR)/$(BUILDROOT_DIR); cp configs/$(CONFIG_TOOLCHAIN) .config
	make -C $(SRC_DIR)/$(BUILDROOT_DIR) oldconfig
	make -C $(SRC_DIR)/$(BUILDROOT_DIR)


$(TMP_DIR)/$(NUTTX_DIR)/ReleaseNotes:
	rm -rf $(TMP_DIR)/
	mkdir $(TMP_DIR)/
	git clone git://git.code.sf.net/p/nuttx/git $(TMP_DIR)/
	cd $(TMP_DIR)/; git checkout nuttx-$(CONFIG_NUTTX_VERSION)


download: $(TMP_DIR)/$(NUTTX_DIR)/ReleaseNotes


setup: download
	rm -rf $(SRC_DIR)/
	mkdir $(SRC_DIR)/
	cp -rf $(TMP_DIR)/. $(SRC_DIR)/
	cd $(SRC_DIR)/$(NUTTX_DIR)/; patch -p2 < ../../$(PATCH_DIR)/$(NUTTX_PATCH)
	cd $(SRC_DIR)/$(APPS_DIR)/; patch -p2 < ../../$(PATCH_DIR)/$(APPS_PATCH)


patch: clean
	mkdir -p $(PATCH_DIR)/
	-diff -Nurp -x '*~' -x '*.orig' $(TMP_DIR)/$(APPS_DIR)/ $(SRC_DIR)/$(APPS_DIR)/ > $(PATCH_DIR)/$(APPS_PATCH)
	-diff -Nurp -x '*~' -x '*.orig' $(TMP_DIR)/$(NUTTX_DIR)/ $(SRC_DIR)/$(NUTTX_DIR)/ > $(PATCH_DIR)/$(NUTTX_PATCH)
	

clean:
	make -C $(SRC_DIR)/$(NUTTX_DIR)/ apps_distclean
	make -C $(SRC_DIR)/$(NUTTX_DIR)/ distclean
	rm $(SRC_DIR)/$(NUTTX_DIR)/include/avr


rebuild: clean configure all	


distclean: clean
	make -C $(SRC_DIR)/$(BUILDROOT_DIR)/ clean
	make -C $(SRC_DIR)/$(BUILDROOT_DIR)/ dirclean
	make -C $(SRC_DIR)/$(BUILDROOT_DIR)/ distclean


menuconfig:
	cd $(SRC_DIR)/$(NUTTX_DIR)/; . ./setenv.sh; make menuconfig


rrr:
	rm -rf $(SRC_DIR)/$(NUTTX_DIR)/
	cp -rf $(TMP_DIR)/$(NUTTX_DIR)/ $(SRC_DIR)/
	cd $(SRC_DIR)/$(NUTTX_DIR)/; patch -p2 < ../../$(PATCH_DIR)/$(NUTTX_PATCH)
	cd $(SRC_DIR)/$(APPS_DIR)/; patch -p2 < ../../$(PATCH_DIR)/$(APPS_PATCH)	


include make.boot
