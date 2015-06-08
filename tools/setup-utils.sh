#!/bin/bash

sudo apt-get install git \
                     autoconf automake \
                     bison flex g++ g++-multilib libgmp-dev libmpfr-dev libmpc-dev gperf libncurses5-dev libqt4-dev zlib1g-dev \
                     avr-libc \
                     lpc21isp libusb-1.0-0-dev minicom

# Setup st-link utility
# http://startingelectronics.org/tutorials/STM32-microcontrollers/programming-STM32-flash-in-Linux/
# http://mainloop.ru/stm32/stm32-stlink-linux.html
ST_LINK=tmp/st-link
# Create build directory
mkdir -p ${ST_LINK}/
# Download sources
git clone git://github.com/texane/stlink.git ${ST_LINK}/
# Build and install tools
cd ${ST_LINK}/; ./autogen.sh; ./configure; make; sudo make install

