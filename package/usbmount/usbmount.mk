################################################################################
#
# usbmount
#
################################################################################

USBMOUNT_VERSION = 9a92e7d622662380f4329e0db17e263509715722
USBMOUNT_SITE = $(call github,rbrito,usbmount,$(USBMOUNT_VERSION))

USBMOUNT_DEPENDENCIES = udev lockfile-progs
USBMOUNT_LICENSE = BSD-2-Clause
USBMOUNT_LICENSE_FILES = debian/copyright

ifeq ($(BR2_INIT_SYSTEMD),y)
define USBMOUNT_INSTALL_TARGET_SYSTEMD
		$(INSTALL) -m 0644 -D $(@D)/usbmount@.service $(TARGET_DIR)/etc/systemd/system/usbmount@.service
endef
endif

define USBMOUNT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/usbmount $(TARGET_DIR)/usr/share/usbmount/usbmount

	$(INSTALL) -m 0755 -D $(@D)/00_create_model_symlink \
		$(TARGET_DIR)/etc/usbmount/mount.d/00_create_model_symlink
	$(INSTALL) -m 0755 -D $(@D)/00_remove_model_symlink \
		$(TARGET_DIR)/etc/usbmount/umount.d/00_remove_model_symlink

	$(INSTALL) -m 0644 -D $(@D)/90-usbmount.rules $(TARGET_DIR)/lib/udev/rules.d/90-usbmount.rules
	$(INSTALL) -m 0644 -D $(@D)/usbmount.conf $(TARGET_DIR)/etc/usbmount/usbmount.conf

	mkdir -p $(addprefix $(TARGET_DIR)/media/usb,0 1 2 3 4 5 6 7)

	$(USBMOUNT_INSTALL_TARGET_SYSTEMD)
endef

$(eval $(generic-package))
