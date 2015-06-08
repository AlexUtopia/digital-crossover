
# Waveshare Electronics # Open1788 board
ifneq (,$(findstring open1788,$(CONFIG_BOARD)))
boot_firmware:
	sudo lpc21isp -control -verify -hex $(EXE_DIR)/nuttx.hex \
	$(CONFIG_BOOT_FIRMWARE_PORT) \
	$(CONFIG_BOOT_FIRMWARE_BAUDRATE_BPS) \
	$(CONFIG_BOARD_OSCILLATOR_FREQ_KHZ)
endif

# ST Microelectronics # STM32VLDISCOVERY board
ifneq (,$(findstring stm32vldiscovery,$(CONFIG_BOARD)))
boot_firmware:
	sudo st-flash write v1 $(EXE_DIR)/nuttx.bin 0x8000000
endif
