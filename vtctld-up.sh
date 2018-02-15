#!/bin/bash
#
# Start vtctld (the web interface)
#
# Access at http://(this host):15000/
#
set -e

grpc_port=15999

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

if ! echo "$my_aliases" | grep --quiet vtctl; then
  echo "This host doesn't have the vtctl alias and so shouldn't run vtctl.  Aborting."
  exit
fi

if pgrep -x "vtctld" > /dev/null; then
  echo "vtctld is already running.  Aborting."
  exit
fi

echo "Starting vtctld..."

$VTROOT/bin/vtctld \
  $TOPOLOGY_FLAGS \
  -cell $cell_name \
  -web_dir $VTTOP/web/vtctld \
  -web_dir2 $VTTOP/web/vtctld2/app \
  -workflow_manager_init \
  -workflow_manager_use_election \
  -service_map 'grpc-vtctl' \
  -backup_storage_implementation file \
  -file_backup_storage_root $VTDATAROOT/backups \
  -log_dir $VTDATAROOT/tmp \
  -port $vtctld_web_port \
  -grpc_port $grpc_port \
  -pid_file $VTDATAROOT/tmp/vtctld.pid \
  > $VTDATAROOT/tmp/vtctld.out 2>&1 &
disown -a

echo "Access vtctld web UI at http://$hostname:$vtctld_web_port"
echo "Send commands with: vtctlclient -server $hostname:$grpc_port ..."

