##进行软链结: ln -s /mnt/a/git/doc/sh/01-locale-profile.sh /etc/profile.d/01-locale-profile.sh

##系统环境设置

# local time
export TZ='Asia/Shanghai'

##开发环境设置

# go
export GO111MODULE=auto
export GOSUMDB=sum.golang.google.cn
export GOPROXY=https://goproxy.io
export GOPATH=/a/go
export GOROOT=/usr/local/go
export GOTOOLS=$GOROOT/pkg/tool
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# java
export JAVA_HOME=/usr/local/java/jdk1.8.0_221
export JAVA_BIN=$JAVA_HOME/bin
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# nodejs
export PATH=/usr/local/node/bin:$PATH

# docker
export DOCKER_HOST=tcp://127.0.0.1:2375
# eval $(docker-machine env default)
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://127.0.0.1:2376"
export DOCKER_CERT_PATH="/home/yangzhou/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"

# other

