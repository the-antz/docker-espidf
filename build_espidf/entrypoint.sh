#!/bin/sh
set -e

if [ -n "$HOST_DIALOUT_ID" ]; then
	groupmod -o -g "$HOST_DIALOUT_ID" host_dialout
	printf "\033[32m"
	echo "id of group host_dialout set to '$HOST_DIALOUT_ID'"
	printf "\033[0m"
else
	printf "\033[31m"
	echo "HOST_DIALOUT_ID not set. Flashing your device probably won't work."
	echo "Please set HOST_DIALOUT_ID to the id of your hosts dialout group, e.g."
	echo "docker run -e HOST_DIALOUT_ID=11 ..."
	printf "\033[0m"
fi
su user
