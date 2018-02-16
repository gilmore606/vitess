#!/bin/bash
#
# Wipe the tablet's MySQL db and metadata, and remove the tablet from vitess's topology
# 
set -e

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

if pgrep -x "mysqld" > /dev/null; then
  echo "mysqld is currently running.  Stop mysqld and vttablet (with tablet-down.sh) before wiping."
  exit
fi

if pgrep -x "vttablet" > /dev/null; then
  echo "vttablet is currently running.  Stop mysqld and vttablet (with tablet-down.sh) before wiping."
  exit
fi

if [ "$my_tablet_type" == "master" ]; then
  echo "This tablet's type is master.  Wiping a shard master seems pretty dangerous to me.  If you really want to do that, do it the hard way."
  exit
fi

echo "You are about to wipe ALL data from this tablet ($my_alias, role $my_tablet_type)."
read -p "Are you sure you want to do this (y/N)? " -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Wiping data..."
  rm -rf $VTDATAROOT/$my_tablet_dir
  echo "Removing tablet from topology..."
  exec vtctlclient -server $vtctl_server:15999 "DeleteTablet" "$my_alias"
  echo "Done.  I hope you meant to do that."
fi
