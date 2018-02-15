#!/bin/bash
#
# Create the initial cell (cell1) in the global vitess topology
#
# We only have to do this once to set up the cell
# Idempotent if you get crazy and re-run it.

set -e
script_root=`dirname "${BASH_SOURCE}"`
source $script_root/env.sh

echo "Creating cell $cell_name in global zookeeper $ZK_SERVER with cell zookeeper $ZK_SERVER..."

$VTROOT/bin/vtctl $TOPOLOGY_FLAGS AddCellInfo \
  -root /vitess/$cell_name \
  -server_address $ZK_SERVER \
  $cell_name || /bin/true


