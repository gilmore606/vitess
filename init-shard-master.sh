#!/bin/bash
#
# Force this tablet to become the master for its shard.
#
# We only do this when bringing up a new shard, to force one tablet to be the new master.
# You should already have brought up the tablet as replica before you do this, and you should have at least
# one other replica tablet up in the shard.

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

if [ "$my_tablet_type" != "replica" ]; then
  echo "my_tablet_type is currently $my_tablet_type ; only a replica can become a new shard's master.  Run this on a replica tablet."
  exit
fi
exec vtctlclient -server vtctl1:15999 "InitShardMaster -force $my_keyspace/$my_shard $my_cell-$my_uid"
echo "Setting my_tablet_type=master in env-tablet.sh..."
sed -i 's/my_tablet_type=replica/my_tablet_type=master/g' $script_root/env-tablet.sh
