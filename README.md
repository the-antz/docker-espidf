# docker-espidf

Builds a [esp-idf](https://github.com/espressif/esp-idf) docker image.

The stuff usually installed by running `esp-idf/install.sh` is compiled from source to (hopefully) allow usage on architectures not officially supported.

A small patch is applied to `esp-idf/tools/idf_tools.py` to make it work on ppc64le.


## build

- clone/checkout the version you want to use (only `4.2` currently)
- optionally update `TZ` and `UID` in `build_espidf/Dockerfile.in` (the uid should match your host uid because you want your bind-mounted project directory to be editable by your regular user)
- make
- docker build

Example:

```
git clone --depth 1 -b 4.2 https://github.com/the-antz/docker-espidf.git
cd docker-espidf
# <-- optionally edit build_espidf/Dockerfile.in -->
make
docker build -t espidf:4.2 build_espidf
```

Make creates `build_espidf/Dockerfile` from:

- build_crosstool/Dockerfile
- build_esp32ulp/Dockerfile
- build_espidf/Dockerfile.in

Make sure you have enough free disk space (needs about 18 GB temporarily - final image is about 2.2 GB) before starting the docker build.
It's also going to take quite a while.

## usage

Copy `conf.example` to `conf` (used by the start script below).

To start the container (assuming your device is connected as `/dev/ttyUSB0`):

`./start.sh /dev/ttyUSB0`

To start the container without a device connected:

`./start.sh`

To start further shells in the container:

`./join.sh`


**Keep stuff you don't want to lose in `/home/user/projects`.**

The container is started with the `--rm` flag, meaning everything not bind-mounted gets deleted when the container stops.
