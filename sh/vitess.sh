#!/bin/sh

# Install MySQL, Vitess supports MySQL 5.6+ and MariaDB 10.0+
# sudo apt-get install mysql-server
# sudo yum install mysql-server
#
# sudo service apparmor stop
# sudo service apparmor teardown # safe to ignore if this errors
# sudo update-rc.d -f apparmor remove

export VTTOP=/4g/database/vt
export VTROOT=/4g/database/vt
export VTDATAROOT=/4g/database/vt/data
export MYSQL_FLAVOR=MySQL56
export PATH=$VTROOT/bin:$GOROOT/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:$JAVA_HOME/bin:$JRE_HOME/bin

# https://vitess.io/docs/get-started/local
cd examples/local
./101_initial_cluster.sh