##文件的路径: cat ~/.bash_aliases
##进行软链结: ln -s /a/git/doc/sh/02-bash_aliases.sh $HOME/.bash_aliases
## alias：添加由alias定义的命令别名
## unalias：取消由alias定义的命令别名


# 文件列表
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# 文件列表-按时间倒序
alias lht='ls -lht'
# 文件列表-按大小倒序
alias lhs='ls -lhS'


# 清除命令行窗口
alias cls='clear'


# 网络监听程序端口 execute command by root user
alias netst='netstat -anptW|grep -i "listen"'


# 数据库 postgresql
alias run-pg='sudo -u postgres psql'
alias start-pg='sudo service postgresql start'


# docker commands
# 启动所有容器
alias dockerstartall='docker container start $(docker ps -aq)'
# 停止所有容器
alias dockerstopall='docker container stop $(docker ps -aq)'
# 重启所有容器
alias dockerrestartall='docker container restart $(docker ps -aq)'
# 杀死所有运行的容器
alias dockerkillall='docker kill $(docker ps -q)'
# 删除所有停止的容器(同下)
alias dockercleanc='docker container prune'
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -aq)'
# 删除所有容器(下面是删未标记的镜像)
alias dockercleaniall='docker rm $(docker ps -a -q)'
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -qf dangling=true)'
# 清除停止的容器及删未标记的镜像
alias dockerclean='dockercleanc || true && dockercleani'


