
##系统环境设置

# local time
export TZ='Asia/Shanghai'

##开发环境设置

# go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOPROXY=https://goproxy.io
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# java
export JAVA_HOME=/usr/local/java/jdk1.8.0_212
export JAVA_BIN=$JAVA_HOME/bin
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# nodejs
export PATH=/usr/local/node/bin:$PATH

##应用服务设置

# minio
export MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
export MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# vitess
export VTTOP=/4g/database/vt
export VTROOT=/4g/database/vt
export VTDATAROOT=/4g/database/vt/data
# export MYSQL_FLAVOR=MySQL56
# export PATH=$VTROOT/bin:$GOROOT/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:$JAVA_HOME/bin:$JRE_HOME/bin


# docker
# export DOCKER_HOST=tcp://127.0.0.1:2375

# other


