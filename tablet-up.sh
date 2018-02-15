#!/bin/bash
#
# Start the vttablet and its mySQL for this host
#
set -e

script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh
source $script_root/env-tablet.sh

dbconfig_dba_flags="\
  -db-config-dba-uname vt_dba \
  -db-config-dba-charset utf8"

dbconfig_flags="$dbconfig_dba_flags \
  -db-config-app-uname vt_app \
  -db-config-app-dbname vt_$my_keyspace \
  -db-config-app-charset utf8 \
  -db-config-appdebug-uname vt_appdebug \
  -db-config-appdebug-dbname vt_$my_keyspace \
  -db-config-allprivs-uname vt_allprivs \
  -db-config-allprivs-dbname vt_$my_keyspace \
  -db-config-allprivs-charset utf8 \
  -db-config-repl-uname vt_repl \
  -db-config-repl-charset utf8 \
  -db-config-filtered-uname vt_filtered \
  -db-config-filtered-dbname vt_$my_keyspace \
  -db-config-filtered-charset utf8"

init_db_sql_file="$VTROOT/config/init_db.sql"
export EXTRA_MY_CNF=$VTROOT/config/mycnf/master_mariadb.cnf
mkdir -p $VTDATAROOT/backups

uid=$my_uid
mysql_port=$my_mysql_port
printf -v alias '%s-%010d' $my_cell $uid
printf -v tablet_dir 'vt_%010d' $uid

# Start MySQL

echo "Starting MySQL for tablet $alias..."
action="init -init_db_sql_file $init_db_sql_file"
if [ -d $VTDATAROOT/$tablet_dir ]; then
  echo "Resuming from existing vttablet dir $VTDATAROOT/tablet_dir"
  action='start'
fi

$VTROOT/bin/mysqlctl \
  -log_dir $VTDATAROOT/tmp \
  -tablet_uid $uid \
  $dbconfig_dba_flags \
  -mysql_port $mysql_port \
  $action &

wait

# Start vttablet

port=$my_base_port
grpc_port=$my_grpc_port
tablet_type=$my_tablet_type
tablet_hostname=''
printf -v alias '%s-%010d' $my_cell $uid
printf -v tablet_dir 'vt_%010d' $uid

echo "Starting vttablet for $alias ..."
$VTROOT/bin/vttablet \
  $TOPOLOGY_FLAGS \
  -log_dir $VTDATAROOT/tmp \
  -tablet-path $alias \
  -tablet_hostname "$tablet_hostname" \
  -init_keyspace $my_keyspace \
  -init_shard $my_shard \
  -init_tablet_type $tablet_type \
  -health_check_interval 5s \
  -enable_semi_sync \
  -enable_replication_reporter \
  -backup_storage_implementation file \
  -file_backup_storage_root $my_backup_dir \
  -restore_from_backup \
  -port $port \
  -grpc_port $grpc_port \
  -service_map 'grpc-queryservice,grpc-tabletmanager,grpc-updatestream' \
  -pid_file $VTDATAROOT/$tablet_dir/vttablet.pid \
  -vtctld_addr http://$vtctld_web_host:$vtctld_web_port/ \
  $dbconfig_flags \
  > $VTDATAROOT/$tablet_dir/vttablet.out 2>&1 &

echo "Access tablet $alias at http://$hostname:$port/debug/status"

disown -a

