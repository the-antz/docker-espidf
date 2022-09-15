FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"
RUN	apt-get update && \
	apt-get install -y build-essential

ARG TZ=Europe/Berlin
ARG UID=1000

# set timezone
RUN	apt-get install -y tzdata && \
	ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata

RUN	\
	# add group / user
	groupadd -r host_dialout && \
	useradd -b /home -m -s /bin/bash -G host_dialout -u $UID user && \
	# deps
	# https://docs.espressif.com/projects/esp-idf/en/v4.4.2/esp32/get-started/linux-setup.html
	apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util && \
	# configure python3 as default
	update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
	# missing in the docs (required for openocd)
	apt-get install -y libusb-1.0-0 && \
	# deps to build python-cryptography from source
	# https://cryptography.io/eb/latest/installation
	apt-get install -y build-essential libssl-dev libffi-dev python3-dev cargo && \
	#
	apt-get install -y neovim

USER user

# add ppc64le platform
COPY --chown=user:user idf_tools.patch /home/user/
# compile python-cryptography from source
COPY --chown=user:user requirements.patch /home/user/
# fix unsupported --no-binary flag
COPY --chown=user:user check_python_dependencies.patch /home/user/

WORKDIR /home/user

RUN	git clone -b v4.4.2 --recursive https://github.com/espressif/esp-idf.git && \
	patch -u esp-idf/tools/idf_tools.py -i idf_tools.patch && \
	patch -u esp-idf/requirements.txt -i requirements.patch && \
	patch -u esp-idf/tools/check_python_dependencies.py -i check_python_dependencies.patch && \
	rm idf_tools.patch && \
	rm requirements.patch && \
	rm check_python_dependencies.patch && \
	rm -rf .cargo

COPY --chown=user:user --from=espidf-toolchain:4.4.2 /home/user/toolchain /home/user/toolchain/

# https://github.com/espressif/esp-idf/blob/master/docs/en/api-guides/tools/idf-tools.rst#tools-installation-directory
ENV IDF_TOOLS_PATH=/home/user/toolchain

# https://docs.espressif.com/projects/esp-idf/en/v4.4.2/esp32/get-started/index.html#customizing-the-tools-installation-path
# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/tools/idf-py.html#global-options
ENV IDF_CCACHE_ENABLE=1

# add toolchain to path
# to check if PATH is set correctly: ~/esp-idf/tools/idf_tools.py check
# to list recommended version: ./esp-idf/tools/idf_tools.py list
RUN	echo "\n# update PATH" >> .bashrc && \
	echo 'PATH="${HOME}/.local/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/xtensa-esp32-elf/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/xtensa-esp32s2-elf/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/xtensa-esp32s3-elf/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/riscv32-esp-elf/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/esp32ulp-elf-binutils/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/esp32s2ulp-elf-binutils/bin:${PATH}"' >> .bashrc && \
	echo 'PATH="${HOME}/toolchain/openocd-esp32/bin:${PATH}"' >> .bashrc && \
	echo '. ${HOME}/esp-idf/export.sh' >> .bashrc
RUN	esp-idf/tools/idf_tools.py --non-interactive install-python-env && \
	rm -r .cache

USER root

COPY /entrypoint.sh /entry

CMD ["/entry"]
