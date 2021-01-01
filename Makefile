
build_espidf/Dockerfile: build_crosstool/Dockerfile build_esp32ulp/Dockerfile build_espidf/Dockerfile.in
	cat build_crosstool/Dockerfile | sed -r 's/^(FROM\s+.+)$$/\1 AS build_crosstool/' > "$@"
	echo "\n\n" >> "$@"
	cat build_esp32ulp/Dockerfile | sed -r 's/^(FROM\s+.+)$$/\1 AS build_esp32ulp/' >> "$@"
	echo "\n\n" >> "$@"
	cat build_espidf/Dockerfile.in >> "$@"
	


.PHONY: clean
clean:
	rm -f build_espidf/Dockerfile

