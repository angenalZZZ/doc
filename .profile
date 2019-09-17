
##系统环境设置

# local time
export TZ='Asia/Shanghai'

##开发环境设置

# go
export GOROOT=/usr/local/go
export GOPATH=/20g/go
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

# docker
# export DOCKER_HOST=tcp://127.0.0.1:2375

# other


