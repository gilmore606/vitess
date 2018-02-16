# These scripts control Vitess nodes at Extole.
#
# A few notes:
#
# env.sh
#   Defines common variables for the entire cell.
#
# env-tablet.sh
#   Defines variables for the individual tablet node.  This is the only file that should vary across nodes.
#
# mysql_auth_server_static_creds.json
#   Defines the access credentials for hitting vtgate with SQL via the MySQL port.  Changing this will not
#   apply dynamically; you'll have to do some privilege stuff.  TBD.
#
# my-overrides.cnf
#   Defines override variables for my.cnf.  Changing this will require a bounce.
#
# lvtctl
#   Convenience shorthand for vtctlclient wired to control the local cluster.  Put it in your path.

