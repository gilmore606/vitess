#!/bin/bash
#
# Take a backup of this tablet.  This will go to $VTDATAROOT/backups, which is probably
# some kind of remote mount.
#
# You can only do this on a replica or rdonly, not a master.
#
script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

exec vtctlclient -server vtctl1:15999 "Backup" "$my_cell-$my_uid"
