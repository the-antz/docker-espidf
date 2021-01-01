FROM ubuntu:18.04
# the required old version of OpenOCD doesn't compile on ubuntu:20.04 (newer versions do)
# xtensa-esp(s2)-elf **does** compile on ubuntu:20.04

RUN	useradd -b /home -m user -s /bin/bash && \
	apt-get update && \
	apt-get install -y build-essential git bison texinfo flex

ARG TZ=Europe/Berlin
ARG OPENOCD_TAG=v0.10.0-esp32-20200709
ARG CROSSTOOL_TAG=esp-2020r3

RUN	\
	# set timezone
	DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata && \
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
	# deps
	apt-get install -y libtool pkg-config libusb-1.0-0-dev && \
	apt-get install -y automake gettext unzip help2man gawk libtool-bin libncurses-dev python3 python3-dev

USER user
WORKDIR /home/user

# clone openocd / crosstool-NG
RUN	git clone --depth 1 --branch $OPENOCD_TAG https://github.com/espressif/openocd-esp32.git && \
	git clone --depth 1 --branch $CROSSTOOL_TAG https://github.com/espressif/crosstool-NG.git && \
	mkdir toolchain
# build openocd
RUN	cd openocd-esp32 && \
	./bootstrap && \
	./configure --prefix=${HOME}/toolchain/openocd-esp32 && \
	make -j $(nproc) && \
	make install-strip
# build crosstool-NG
RUN	cd crosstool-NG && \
	git submodule update --init && \
	./bootstrap && \
	./configure --enable-local && \
	make
# build xtensa-esp32-elf
RUN	cd crosstool-NG && \
	./ct-ng xtensa-esp32-elf && \
	./ct-ng build.$(nproc) && \
	chmod -R u+w builds/xtensa-esp32-elf && \
	mv builds/xtensa-esp32-elf ${HOME}/toolchain/
# build xtensa-esp32s2-elf
RUN	cd crosstool-NG && \
	./ct-ng xtensa-esp32s2-elf && \
	./ct-ng build.$(nproc) && \
	chmod -R u+w builds/xtensa-esp32s2-elf && \
	mv builds/xtensa-esp32s2-elf ${HOME}/toolchain/
