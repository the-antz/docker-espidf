.PHONY: espidf toolchain

espidf: toolchain
	cd build_espidf && docker build -t espidf:4.4.2 .

toolchain:
	cd build_toolchain && docker build -t espidf-toolchain:4.4.2 .
