#!/bin/bash
#
# Stop vtctld (the web interface)
#
set -e

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

if ! pgrep -x "vtctld" > /dev/null; then
  echo "vtctld is not running."
  exit
fi

pid=`cat $VTDATAROOT/tmp/vtctld.pid`
echo "Stopping vtctld..."
kill $pid
sleep 1
if pgrep -x "vtctld" > /dev/null; then
  echo "vtctld did not stop yet!  Experience anxiety."
else
  echo "stopped."
fi

