#!/bin/bash
#
# Shut down any zk nodes I happen to run.
#

set -e
script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

echo "Stopping ZK servers..."
for zkid in $zkids; do
  if echo "$my_aliases" | grep --quiet zk$zkid; then
    echo "  stopping zk$zkid"
    $VTROOT/bin/zkctl -zk.myid $zkid -zk.cfg $zkcfg -log_dir $VTDATAROOT/tmp shutdown
  fi
done
echo "Done."
