FROM ubuntu:18.04
# doesn't compile with the newer gcc version in ubuntu:20.04

RUN	useradd -b /home -m user -s /bin/bash && \
	apt-get update && \
	apt-get install -y build-essential git bison texinfo flex

ARG ESP32ULP_VERSION=2.28.51-esp-20191205
ARG ESP32ULP_TAG=v2.28.51-esp-20191205

USER user
WORKDIR /home/user

# clone repo
RUN	git clone --depth 1 --branch $ESP32ULP_TAG https://github.com/espressif/binutils-esp32ulp.git && \
	mkdir toolchain

RUN	\
	# build esp32ulp-elf-binutils
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
