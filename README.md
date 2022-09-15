# docker-espidf

Builds a [esp-idf](https://github.com/espressif/esp-idf) docker image.

The toolchains usually installed by running `esp-idf/install.sh` are compiled from source to (hopefully) allow usage on architectures not officially supported.

Some minor patches are applied to make it work on ppc64le.

For prebuild images, see [https://hub.docker.com/r/theantz/espidf](https://hub.docker.com/r/theantz/espidf).

## build

- clone/checkout the branch for the version you want to use
- optionally update `TZ` and `UID` in `build_espidf/Dockerfile` (the uid should match your host uid because you want your bind-mounted project directory to be editable by your regular user)
- run make

Example:

```
git clone --depth 1 -b 4.4.2 https://github.com/the-antz/docker-espidf.git
cd docker-espidf
# <-- optionally edit build_espidf/Dockerfile -->
sudo make
```

This creates the docker images `espidf-toolchain` and `espidf`.
You can delete `espidf-toolchain` after `espidf` was created.

The toolchain compilation is going to take quite a while.

## usage

If you want to change anything in `conf.default`, create a copy `conf` (used by the start script below).

To start the container (assuming your device is connected as `/dev/ttyUSB0`):

`./start.sh /dev/ttyUSB0`

To start the container without a device connected:

`./start.sh`

To start further shells in the container:

`./join.sh`


**Keep stuff you don't want to lose in the `projects` folder!**

The container is started with the `--rm` flag, meaning everything not bind-mounted gets deleted when the container stops.
