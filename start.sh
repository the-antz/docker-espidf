#!/bin/sh
set -e

if [ $# -ge 1 ]; then
	if [ $# -gt 1 ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
		echo "\nExample usage:\n"
		echo "./start.sh"
		echo "./start.sh /dev/ttyUSB0\n"
		exit 0
	fi
	DEVICE="$1"
fi

. ./conf

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

CMD="docker run --rm -it --name espidf -v ${PROJECT_DIR}:/home/user/projects"
[ -n "$DEVICE" ] && CMD="$CMD --device=${DEVICE} -e HOST_DIALOUT_ID=${HOST_DIALOUT_ID}"
CMD="$CMD $IMAGE"
echo "$CMD"
$CMD
