#
# Set env params for all vitess control scripts
#

export hostname=`hostname -f`
export vtctld_web_port=15000
export vtctld_web_host=vtctl1

zkcfg=(\
    "1@zk1:28881:38881:21811" \
    "2@zk2:28882:38882:21812" \
    "3@zk3:28883:38883:21813" \
    )
printf -v zkcfg ",%s" "${zkcfg[@]}"
zkcfg=${zkcfg:1}
zkids='1 2 3'
zkhosts='zk1 zk2 zk3'
export ZK_SERVER="zk1:21811,zk2:21812,zk3:21813"

export VTTOP=$VTROOT/src/github.com/youtube/vitess
export VT_MYSQL_ROOT=/usr/local/mysql

export TOPOLOGY_FLAGS="-topo_implementation zk2 -topo_global_server_address $ZK_SERVER -topo_global_root /vitess/global"
export cell_name=cell1
export vtctl_server=vtctl1
export my_aliases=`grep $hostname /etc/hosts`

mkdir -p $VTDATAROOT/tmp

