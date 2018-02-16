#!/bin/bash
#
# Stop the vttablet and MySQL instance for this host.
#
set -e

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

if pgrep -x "vttablet" > /dev/null; then
  echo "Stopping vttablet for $my_alias ..."
  pid=`cat $VTDATAROOT/$my_tablet_dir/vttablet.pid`
  kill $pid
  while ps -p $pid > /dev/null; do sleep 1; done
else
  echo "vttablet not running."
fi
echo "Stopping MySQL for tablet $my_alias ..."
$VTROOT/bin/mysqlctl \
  -db-config-dba-uname vt_dba \
  -tablet_uid $my_uid \
  shutdown &

wait

echo "Done."
