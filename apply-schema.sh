#!/bin/bash
#
# Apply a sql file to my keyspace.
#

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

exec vtctlclient -server vtctl1:15999 "ApplySchema" "-sql" "$(cat $1)" "$my_keyspace"
