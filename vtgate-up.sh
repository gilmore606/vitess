#!/bin/bash
#
# Start vtgate (the MySQL proxy interface)
#
set -e

web_port=15005
grpc_port=15991
mysql_server_port=15306
mysql_server_socket_path="/tmp/mysql.sock"

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

if ! echo "$my_aliases" | grep --quiet vtgate; then
  echo "This host doesn't have the vtgate alias and so shouldn't run vtgate.  Aborting."
  exit
fi

if pgrep -x "vtgate" > /dev/null; then
  echo "vtgate is already running.  Aborting."
  exit
fi

echo "Starting vtgate..."

$VTROOT/bin/vtgate \
  $TOPOLOGY_FLAGS \
  -log_dir $VTDATAROOT/tmp \
  -port $web_port \
  -grpc_port $grpc_port \
  -mysql_server_port $mysql_server_port \
  -mysql_server_socket_path $mysql_server_socket_path \
  -mysql_auth_server_static_file "./mysql_auth_server_static_creds.json" \
  -cell $my_cell \
  -cells_to_watch $my_cell \
  -tablet_types_to_wait MASTER,REPLICA \
  -gateway_implementation discoverygateway \
  -service_map 'grpc-vtgateservice' \
  -pid_file $VTDATAROOT/tmp/vtgate.pid \
  > $VTDATAROOT/tmp/vtgate.out 2>&1 &

echo "Access vtgate at http://$hostname:$web_port/debug/status"

disown -a

