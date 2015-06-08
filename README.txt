
#
# Настройка окружения 
#

1) установить необходимые пакеты (необходимы права суперпользователя)
    ./tools/setup-utils.sh
2) настроить прокси для git и wget, если нужно
    ./tools/setup-proxy.sh <username> <userpasswd>
3) скачать проект nuttx из официального репозитария разработки (в директории tmp/ хранится "чистый" проект;
   в директории src/ хранится копия содержимого tmp/ с наложенными патчами
   patch/apps.patch и patch/nuttx.patch)
    make setup


#
# Сборка и установка toolchain'а
#

1) собрать и установить toolchain
    make toolchain


#
# Сборка прошивки
#

1) собрать прошивку
    make configure
    make all
2) прошивки (intel-hex и bin файлы) будут находиться в директории exe/


#
# Работа с menuconfig
#

1) вызвать menuconfig
    make configure
    make menuconfig
2) произвести измения конфигурации и сохранить её как текущую конфигурацию
3) сохранить новую конфигурацию
	make configure_update


#
# Коммит проекта (исходные коды nuttx коммиту не подлежат)
#

1) создать патчи (patch/apps.patch и patch/nuttx.patch)
    make patch
2) осуществить коммит проекта (любым удобным способом)


#
# Загрузка прошивки в микроконтроллер
#

1) загрузить прошивку в микроконтроллер:
   a) для платы Waveshare Electronics # Open1788 необходимо определить
      переменные конфигурации:
      - CONFIG_BOARD_OSCILLATOR_FREQ_KHZ - частота кварцевого резонатора / генератора на выводах XTAL1 и XTAL2 [кГц];
      - CONFIG_BOOT_FIRMWARE_PORT - последовательный порт (COM порт) для загрузки прошивки
          RXD <-- P0[0]/CAN_RD1/U3_TXD/I2C1_SDA/U0_TXD;
          TXD --> P0[1]/CAN_TD1/U3_RXD/I2C1_SCL/U0_RXD;
          DTR --> nRESET;
          RTS --> P2[10]/nEINT0/NMI;
      - CONFIG_BOOT_FIRMWARE_BAUDRATE_BPS - скорость загрузки прошивки в микроконтроллер [бит/с];
    b) для платы ST Microelectronics # STM32VLDISCOVERY никаких дополнительных переменных
       конфигурации определять не нужно
    make boot_firmware
