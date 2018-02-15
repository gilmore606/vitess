#!/bin/bash
#
# Bring up vitess zk servers this host should run
#

set -e
script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

echo "Starting zk servers..."
for zkid in $zkids; do
  if echo "$my_aliases" | grep --quiet zk$zkid; then
    printf -v zkdir 'zk_%03d' $zkid
    if [ -f $VTDATAROOT/$zkdir/myid ]; then
      echo "Resuming zk$zkid from existing ZK data dir $VTDATAROOT/$zkdir"
      action='start'
    else
      echo "Initializing zk$zkid fresh at $VTDATAROOT/$zkdir"
      action='init'
    fi
    $VTROOT/bin/zkctl -zk.myid $zkid -zk.cfg $zkcfg -log_dir $VTDATAROOT/tmp $action \
      > $VTDATAROOT/tmp/zkctl_$zkid.out 2>&1 &
    pids[$zkid]=$!
  fi
done

echo "Waiting for zk servers to be ready..."
for zkid in $zkids; do
  if echo "$my_aliases" | grep --quiet zk$zkid; then
    if ! wait ${pids[$zkid]}; then
      echo "ZK server zk$zkid failed to start.  See log:"
      echo "    $VTDATAROOT/tmp/zkctl_$zkid.out"
    fi
  fi
done

echo "Done."

