#!/bin/sh
#
# Copyright (c) 2016 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Run tunslip in a loop. This way we can restart qemu and do not need
# to manually restart tunslip process that creates the tun0 device.

if [ ! -f ./tunslip ]; then
    if [ ! -f $ZEPHYR_BASE/net/ip/tools/tunslip ]; then
	echo "Cannot find tunslip executable."
	exit 1
    fi
    DIR=$ZEPHYR_BASE/net/ip/tools
else
    DIR=.
fi

if [ `id -u` != 0 ]; then
    echo "Run this script as a root user!"
    exit 2
fi

STOPPED=0
trap ctrl_c INT TERM

function ctrl_c() {
    STOPPED=1
}

while [ $STOPPED -eq 0 ]; do
    $DIR/tunslip -s `readlink /tmp/slip.dev` 192.0.2.1 255.255.255.0
done