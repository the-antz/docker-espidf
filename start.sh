#!/bin/sh
set -e

# parse args
if [ $# -ge 1 ]; then
	if [ $# -gt 1 ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
		echo "\nExample usage:\n"
		echo "./start.sh"
		echo "./start.sh /dev/ttyUSB0\n"
		exit 0
	fi
	DEVICE="$1"
fi

# load config
if [ -r "./conf" ]; then
	. ./conf
else
	. ./conf.default
fi

ERR_MSG=""
[ -z "$IMAGE" ] && ERR_MSG='IMAGE not set.'
[ -w "$PROJECT_DIR" ] || ERR_MSG='PROJECT_DIR not set or write permission missing.'
if [ -n "$DEVICE" ]; then
	[ -z $HOST_DIALOUT_ID ] && ERR_MSG='HOST_DIALOUT_ID not set.'
	[ -e "$DEVICE" ] || ERR_MSG="Device '$DEVICE' not found."
fi
if [ ! -z "$ERR_MSG" ]; then
	echo $ERR_MSG >&1
	exit 5
fi

PROJECT_DIR="$(realpath "$PROJECT_DIR")"

CMD1="docker run --rm -it --name espidf"
CMD3=""
[ -n "$DEVICE" ] && CMD3="--device=${DEVICE} -e HOST_DIALOUT_ID=${HOST_DIALOUT_ID}"
echo $CMD1 -v "${PROJECT_DIR}:/home/user/projects" $CMD3 $IMAGE
$CMD1 -v "${PROJECT_DIR}:/home/user/projects" $CMD3 $IMAGE
