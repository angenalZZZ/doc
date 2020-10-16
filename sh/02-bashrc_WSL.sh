##文件的路径:  ~/.bashrc  ~/.zshrc
##Windows10/Linux(WSL) 添加如下内容,到文件尾部.

##系统环境变量
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export PATH=$PATH:~/.antigen/bundles/robbyrussell/oh-my-zsh/lib:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/pip:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/svn-fast-info:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/colorize:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/github:~/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/python:~/.antigen/bundles/zsh-users/zsh-autosuggestions:~/.antigen/bundles/zsh-users/zsh-completions:~/.antigen/bundles/Vifon/deer:~/.antigen/bundles/willghatch/zsh-cdr:~/.antigen/bundles/zsh-users/zaw:~/.antigen/bundles/zsh-users/zaw/functions:~/.antigen/bundles/zsh-users/zsh-syntax-highlighting

##本地时区设置
export TZ='Asia/Shanghai'

##本地开发环境

# go
export GO111MODULE=auto
# export GOSUMDB=sum.golang.google.cn
export GOPROXY=https://goproxy.io
export GOPATH=/mnt/a/go
export GOROOT=/usr/local/go
export GOTOOLS=$GOROOT/pkg/tool
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# java
# export JAVA_HOME=/usr/local/java/jdk1.8.0_221
# export JAVA_BIN=$JAVA_HOME/bin
# export JRE_HOME=$JAVA_HOME/jre
# export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
# export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# nodejs
# export PATH=/usr/local/node/bin:$PATH

# docker
export DOCKER_HOST=tcp://127.0.0.1:2375
# docker_k8s: eval $(docker-machine env default)
# export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://192.168.1.6:2376"
# export DOCKER_CERT_PATH=$HOME/.docker/machine/machines/default
# export DOCKER_MACHINE_NAME=default

# other
