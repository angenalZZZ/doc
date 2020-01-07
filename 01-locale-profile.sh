##文件的路径: /etc/profile.d/01-locale-profile.sh  =>  /etc/profile
##进行软链结: ln -s /*/doc/sh/01-locale-profile.sh /etc/profile.d/01-locale-profile.sh

##系统环境设置

# local time
export TZ='Asia/Shanghai'

##开发环境设置

# go
export GO111MODULE=auto
export GOPROXY=https://goproxy.io
export GOPATH=/20g/go
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

##应用服务设置

# docker
export DOCKER_HOST=tcp://127.0.0.1:2375

# other


