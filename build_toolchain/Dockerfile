FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
RUN	useradd -b /home -m user -s /bin/bash && \
	apt-get update && \
	apt-get install -y build-essential

ARG TZ=Europe/Berlin

ARG OPENOCD_TAG=v0.11.0-esp32-20220411
#ARG CROSSTOOL_TAG=esp-2022r1
ARG CROSSTOOL_TAG=esp-2021r2-patch3

#ARG ESP32ULP_VERSION=2.28.51-esp-20211130
#ARG ESP32ULP_TAG=v2.28.51-esp-20211130
ARG ESP32ULP_VERSION=2.28.51-esp-20191205
ARG ESP32ULP_TAG=v2.28.51-esp-20191205

# set timezone
RUN	apt-get install -y tzdata && \
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata

# deps
# https://docs.espressif.com/projects/esp-idf/en/v4.4.2/esp32/get-started/linux-setup-scratch.html
RUN	apt-get install -y git wget libncurses-dev flex bison gperf python3 python3-pip python3-setuptools \
		python3-serial python3-cryptography python3-future python3-pyparsing python3-pyelftools \
		cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0 && \
	apt-get install -y gawk gperf grep gettext python python-dev automake bison flex texinfo help2man \
		libtool libtool-bin make && \
# missing in the docs
	apt-get install -y pkg-config libusb-1.0-0-dev unzip

USER user
WORKDIR /home/user

# clone openocd / crosstool-NG / binutils-esp32ulp
RUN	git clone --depth 1 --branch $OPENOCD_TAG https://github.com/espressif/openocd-esp32.git && \
	git clone --depth 1 --branch $CROSSTOOL_TAG https://github.com/espressif/crosstool-NG.git && \
	git clone --depth 1 --branch $ESP32ULP_TAG https://github.com/espressif/binutils-esp32ulp.git && \
	mkdir toolchain
# build openocd
RUN	cd openocd-esp32 && \
	./bootstrap && \
	./configure --prefix=${HOME}/toolchain/openocd-esp32 && \
	make -j $(nproc) && \
	make install-strip && \
	make clean
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
	mv builds/xtensa-esp32-elf ${HOME}/toolchain/ && \
	rm -rf .build
# build xtensa-esp32s2-elf
RUN	cd crosstool-NG && \
	./ct-ng xtensa-esp32s2-elf && \
	./ct-ng build.$(nproc) && \
	chmod -R u+w builds/xtensa-esp32s2-elf && \
	mv builds/xtensa-esp32s2-elf ${HOME}/toolchain/ && \
	rm -rf .build
# build xtensa-esp32s3-elf
RUN	cd crosstool-NG && \
	./ct-ng xtensa-esp32s3-elf && \
	./ct-ng build.$(nproc) && \
	chmod -R u+w builds/xtensa-esp32s3-elf && \
	mv builds/xtensa-esp32s3-elf ${HOME}/toolchain/ && \
	rm -rf .build
# build riscv32-esp-elf
RUN	cd crosstool-NG && \
	./ct-ng riscv32-esp-elf && \
	./ct-ng build.$(nproc) && \
	chmod -R u+w builds/riscv32-esp-elf && \
	mv builds/riscv32-esp-elf ${HOME}/toolchain/ && \
	rm -rf .build
# requirements for binutils-esp32ulp / binutils-esp32s2ulp
# (build fails on newer gcc)
# https://github.com/espressif/binutils-esp32ulp/issues/19
# https://github.com/espressif/binutils-esp32ulp/blob/master/.gitlab-ci.yml#L20
# https://github.com/espressif/binutils-esp32ulp/blob/master/.gitlab-ci.yml#L118
USER root
RUN	apt-get install -y gcc-7 g++-7 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7
USER user
# build esp32ulp-elf-binutils
RUN	\
	cd binutils-esp32ulp && \
	export ESP_VERSION=$ESP32ULP_VERSION && \
	sed -ri 's/(.*)(bfd_version_string=)(.*)( ;\\)$/\1\2"\\"$(ESP_VERSION)\\""\4/' bfd/Makefile.in && \
	./configure --target=esp32ulp-elf --prefix=/${HOME}/toolchain/esp32ulp-elf-binutils --disable-doc --disable-gdb --disable-libdecnumber --disable-readline --disable-sim && \
	echo "MAKEINFO = :" >> Makefile && \
	make -j $(nproc) && \
	make install-strip && \
	# cleanup
	git reset --hard && \
	git clean -f -d -x && \
	# build esp32s2ulp-elf-binutils
	sed -ri 's/(.*)(bfd_version_string=)(.*)( ;\\)$/\1\2"\\"$(ESP_VERSION)\\""\4/' bfd/Makefile.in && \
	./configure --target=esp32s2ulp-elf --prefix=/${HOME}/toolchain/esp32s2ulp-elf-binutils --disable-doc --disable-gdb --disable-libdecnumber --disable-readline --disable-sim && \
	echo "MAKEINFO = :" >> Makefile && \
	make -j $(nproc) && \
	make install-strip
