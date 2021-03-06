#
# MT7628 Profiles
#

define Build/tplink-header
	$(STAGING_DIR_HOST)/bin/mktplinkfw2 -a 0x4 -V "ver. 2.0" -B $(1) \
		-o $@.new -k $@ -r $(IMAGE_ROOTFS) && mv $@.new $@
endef

define Build/prepend-to
    dd bs=1 seek=$(1) if=$@ of=$@.new && mv $@.new $@
endef

define Device/mt7628
  DTS := MT7628
  BLOCKSIZE := 64k
  IMAGE_SIZE := $(ralink_default_fw_size_4M)
  DEVICE_TITLE := MediaTek MT7628 EVB
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport
endef
TARGET_DEVICES += mt7628

define Device/hc5661a
  DTS := HC5661A
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DEVICE_TITLE := HiWiFi HC5661A
endef
TARGET_DEVICES += hc5661a

define Device/miwifi-nano
  DTS := MIWIFI-NANO
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DEVICE_TITLE := Xiaomi MiWiFi Nano
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport
endef
TARGET_DEVICES += miwifi-nano

define Device/tl-wr841n-v13
  DTS := TL-WR841NV13
  IMAGE_SIZE := 7808k
  DEVICE_TITLE := TP-Link TL-WR841N v13
  SUPPORTED_DEVICES := tl-wr841n-v13
  DEVICE_PACKAGES :=
  KERNEL := $(KERNEL_DTB) | prepend-to 448 | uImage lzma
  # KERNEL_INITRAMFS := $(KERNEL_DTB) | tplink-header TL-WR841Nv13 -c        # untested
  IMAGES += factory.bin tftp.bin
  IMAGE/factory.bin := pad-extra 131584 | append-kernel | tplink-header TL-WR841Nv13 -j
  IMAGE/sysupgrade.bin := append-kernel | tplink-header TL-WR841Nv13 -j -s | append-metadata
  IMAGE/tftp.bin := pad-extra 131072 | $$(sysupgrade_bin)
endef
TARGET_DEVICES += tl-wr841n-v13

define Device/gl-mt300n-v2
  DTS := GL-MT300N-V2
  IMAGE_SIZE := 16064k
  DEVICE_TITLE := GL-iNet GL-MT300N-V2
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci
endef
TARGET_DEVICES += gl-mt300n-v2

define Device/vocore2
  DTS := VOCORE2
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DEVICE_TITLE := VoCore VoCore2
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport \
    kmod-sdhci-mt7620
endef
TARGET_DEVICES += vocore2

define Device/wl-wn575a3
  DTS := WL-WN575A3
  IMAGE_SIZE := $(ralink_default_fw_size_8M)
  DEVICE_TITLE := Wavlink WL-WN575A3
endef
TARGET_DEVICES += wl-wn575a3

define Device/wrtnode2p
  DTS := WRTNODE2P
  IMAGE_SIZE := $(ralink_default_fw_size_16M)
  DEVICE_TITLE := WRTnode 2P
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport
endef
TARGET_DEVICES += wrtnode2p

define Device/duzun-dm06
  DTS := DUZUN-DM06
  DEVICE_TITLE := DuZun DM06
  DEVICE_PACKAGES := kmod-usb2 kmod-usb-ohci kmod-usb-ledtrig-usbport
endef
TARGET_DEVICES += duzun-dm06

define Device/mac1200r-v2
  DTS := MAC1200RV2
  DEVICE_TITLE := Mercury MAC1200R v2.0
endef
TARGET_DEVICES += mac1200r-v2

define Device/wcr-1166ds
  DTS := WCR-1166DS
  BUFFALO_TAG_PLATFORM := MTK
  BUFFALO_TAG_VERSION := 9.99
  BUFFALO_TAG_MINOR := 9.99
  IMAGES += factory.bin
  IMAGE/sysupgrade.bin := trx | pad-rootfs | append-metadata
  IMAGE/factory.bin := \
	trx -M 0x746f435c | pad-rootfs | append-metadata | \
	buffalo-enc WCR-1166DS $$(BUFFALO_TAG_VERSION) -l | \
	buffalo-tag-dhp WCR-1166DS JP JP | buffalo-enc-tag -l | \
	buffalo-dhp-image
  DEVICE_TITLE := Buffalo WCR-1166DS
endef
TARGET_DEVICES += wcr-1166ds
