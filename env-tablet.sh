#
# Set vars specific to this instance's tablet
#
# Eventually this should pull from something intelligent or some shit.  I don't know.  Fuck.
#
my_cell=cell1
my_keyspace=event_keyspace
my_shard=0
my_uid=101
my_mysql_port=17001
my_grpc_port=16001
my_base_port=15001
my_tablet_type=master
my_backup_dir=$VTDATAROOT/backups
printf -v my_alias '%s-%010d' $my_cell $my_uid
printf -v my_tablet_dir 'vt_%010d' $my_uid
