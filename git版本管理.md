# **[安装Git for Mac & Linux](https://gist.github.com/derhuerst/1b15ff4652a867391f03)**、[安装Git for Windows](https://github.com/git-for-windows/git/releases)、**[安装Gitea Server](#安装gitea-server)**

#### Global Config
~~~bash
# https://kbroman.org/github_tutorial/pages/first_time.html
> git config --global --list                    # 查询全局所有配置
> git config --global user.name                 # 查询全局git用户配置
> git config --global user.name "yangzhou"      # 修改全局git用户配置
> git config --global user.email "angenal@hotmail.com" # 修改全局git用户账号邮箱

# 保存用户名密码和仓库链接在硬盘中(~/.git-credentials)，而不用在每次push时都输入密码。
> git config --global credential.helper store   # 提交push时不用每次都输入用户名密码的方法(删除参数--global会只对当前仓库生效)
> git credential-manager uninstall              # 有时需要把项目的用户名和密码删掉>存储用户名和密码的文件记录~/.git-credentials
> git config --global color.ui true             # 在终端中启用彩色输出
> git config --global core.editor emacs         # 使用emacs文本编辑器(可选)
> git config --global alias.co "checkout"       # 修改全局git用户的快捷键\命令
> git config --global alias.br "branch"
> git config --global alias.ci "commit"
> git config --global alias.st "status"
> git config --global alias.l "config --local -l" # 查看当前分支remote.origin.url,branch.master.remote=origin
> git config --global alias.ls "log --oneline"    # 一行展示日志+show详情 > git ls ; git show <commit-head-id>
> git config --global alias.dog "log --all --decorate --oneline --graph" # 方便查看日志的快捷键 > git dog
> git config --global alias.hist "log --graph --date-order --date=short \ # git hist --all [--branches]
  --pretty=format:'%C(auto)%h%d %C(reset)%s %C(bold blue)%ce %C(reset)%C(green)%cr (%cd)'"
> git config --global alias.lg1 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - \
  %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
> git config --global alias.lg2 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - \
  %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) \
  %C(dim white)- %an%C(reset)' --all"

> git config --global --edit                    # 直接编辑全局配置文件 ~/.gitconfig
[user]
        name = yangzhou
        email = angenal@hotmail.com
[http]
        postBuffer = 524288000
        sslVerify = true
        lowSpeedLimit = 0
        lowSpeedTime = 999999
#       proxy = http://127.0.0.1:1087
#[https]
#       proxy = http://127.0.0.1:1087
[alias]
        adog = log --all --decorate --oneline --graph
        ls = log --oneline
        tree = forest --pretty=format:'%C(red)%h %C(magenta)(%ar) %C(blue)%an %C(reset)%s' --style=15 --reverse
        hist = log --graph --date-order --date=short --pretty=format:'%C(auto)%h%d %C(reset)%s %C(bold blue)%ce %C(reset)%C(green)%cr (%cd)'
        co = checkout
        br = branch
        ci = commit
        st = status
        dog = log --all --decorate --oneline --graph
[color]
        ui = true
[diff]
        tool = vsdiffmerge
[difftool]
        prompt = true
# 参考: https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs

# 设置proxy，当github打不开时，参考(可选) https://github.com/docmirror/dev-sidecar
# 下载安装(可选) http://dev-sidecar.docmirror.cn

# 1.通过修改默认配置, 解决网络问题..
> git config --global --unset http.proxy        # 关闭http代理
> git config --global --unset https.proxy       # 关闭https代理
> git config --global http.sslVerify "false"    # 关闭ssl验证(网络异常时,可选)
> git config --global http.https://github.com.proxy '' # 清空github.com网络代理(可选)
> git config --global http.postBuffer 524288000 # 上传文件大小;限制500M=1024*1024*500(默认100M)
> git config --global http.lowSpeedLimit 0      # 下载文件限制;
> git config --global http.lowSpeedTime 999999  # 下载文件时速;
> git clone --depth=1 https://***/***/***.git   # 下载失败时，1.首先浅层clone..
> git fetch --unshallow                         # 下载更快..然后更新远程库到本地; 2.或者使用SSH进行下载

# 2.通过修改hosts, 获取以下 DNS Resource Records, 解决CDN被屏蔽(DNS污染)问题..
# github > fix git clone github project failed > /etc/hosts
# 52.69.186.44 github.com                   # 查询> https://github.com.ipaddress.com
# 52.69.186.44 www.github.com
199.232.69.194 github.global.ssl.fastly.net # 查询> https://fastly.net.ipaddress.com/github.global.ssl.fastly.net
185.199.109.133 assets-cdn.github.com       # 查询> https://github.com.ipaddress.com/assets-cdn.github.com
185.199.109.133 raw.github.com
185.199.109.133 raw.githubusercontent.com   # 查询> https://githubusercontent.com.ipaddress.com/raw.githubusercontent.com
186.199.110.133 raw.githubusercontent.com
187.199.111.133 raw.githubusercontent.com
185.199.109.133 gist.githubusercontent.com
185.199.109.133 cloud.githubusercontent.com
185.199.109.133 camo.githubusercontent.com
185.199.109.133 desktop.githubusercontent.com
185.199.109.133 marketplace-screenshots.githubusercontent.com
185.199.109.133 repository-images.githubusercontent.com
185.199.109.133 user-images.githubusercontent.com
185.199.109.133 avatars0.githubusercontent.com
185.199.109.133 avatars1.githubusercontent.com
185.199.109.133 avatars2.githubusercontent.com
185.199.109.133 avatars3.githubusercontent.com
185.199.109.133 avatars4.githubusercontent.com
185.199.109.133 avatars5.githubusercontent.com
185.199.109.133 avatars6.githubusercontent.com
185.199.109.133 avatars7.githubusercontent.com
185.199.109.133 avatars8.githubusercontent.com

# 3.刷新dns缓存..
$ sudo killall -HUP mDNSResponder
$ sudo dscacheutil -flushcache
> ipconfig /flushdns  # on windows

> git config --system -l # show windows system config
> git config --system -e # [--edit] windows system config
# http.sslVerify=false
# http.sslbackend=openssl
# http.sslcainfo=C:/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt
# credential.helper=manager

> git config --system core.longpaths true # enabled log file paths in git (run as Administrator)
# If this repository contains git submodules. 
# To add the submodules to the project, navigate to the repository root and type:
> git submodule update --init --recursive

# 设置SSH-Key: github.com/settings/keys
> ssh-keygen -t rsa -C "angenal@hotmail.com"
# 1.创建SSHKey # 2.复制公钥文件 $ pbcopy < ~/.ssh/id_rsa.pub >> github.com/settings/ssh
# 3.测试SSHKey>ssh -T git@github.com # 4.设置(可选)<hosts> 52.74.223.119 github.com
~~~

#### Create a new repository from your `LAN(local area network)` `origin`.
~~~bash
git clone http://10.1.1.10/angenal/CSharpOpen.git
cd CSharpOpen
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
~~~

#### Create a new repository, push into github.com `remote` `origin`.
~~~bash
echo "# CSharpOpen" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/angenal/CSharpOpen.git
git push -u origin master
~~~

#### Change remote path `http` to `git`
~~~bash
# query remote origin url
git remote -v
 origin  https://github.com/angenal/CSharpOpen.git (fetch)
 origin  https://github.com/angenal/CSharpOpen.git (push)
# change remote origin url
git remote set-url origin git@github.com:angenal/CSharpOpen.git
git remote -v
 origin  git@github.com:angenal/CSharpOpen.git (fetch)
 origin  git@github.com:angenal/CSharpOpen.git (push)
~~~

#### Push an existing folder.
~~~bash
cd CSharpOpen
git init
git remote add origin http://10.1.1.10/angenal/CSharpOpen.git
git add .
git commit -m "Initial git"
git push -u origin master
~~~

#### Push an existing Git repository.
~~~bash
cd CSharpOpen
git remote rename origin old-origin  # rename a old-origin to new origin
git remote add origin https://github.com/angenal/CSharpOpen.git
# git remote set-url origin https://github.com/angenal/CSharpOpen.git # update remote origin url
git push -u origin master
git push -u origin --all
git push -u origin --tags
~~~

#### Contributing and `PR` for your new-feature.
~~~bash
# 1. fork it
git clone https://github.com/angenal/CSharpOpen && cd CSharpOpen # 2. download your fork
git checkout -b new-feature     # 3. create your feature branch
git add .                       # 4. make changes and add them into git
git commit -m 'new feature'     # 5. commit your changes
git push origin new-feature     # 6. push to the branch new-feature
# 7. create new pull request.
~~~

# [新建git项目与git发布`点击看其他教程`](http://wangchujiang.com/linux-command/c/git.html)


####  1.新建项目-目录-初始化本地git仓库(1个隐藏的目录.git)

~~~bash
$ rm -rf * && rm -rf .git/                   # 初始化之前,清空当前目录 > del /f/s/q *
git init  # 初始化目录=当前工作区, .git/*(index索引add的暂存区数据,objects存储commit的本地仓库数据)
git config --local user.name "用户名"        # 当前项目git用户配置
git config --local user.email "用户邮箱地址"  # 当前项目git用户邮箱地址>注册远程git账号
git config --local -l                        # 当前目录所在仓库的用户配置
~~~

####  2.检查git状态(当前工作区：新增文件要add [或添到.gitignore], 变更文件要commit)

~~~bash
git status #工作区如果干净, 还得查stash中间状态: git stash list 然后还原git stash apply stash@{0} 最后commit
~~~

####  3.新建文件(-目录-cmd: 新建mkdir, 打开cd, 删除rd /s/q [目录名])

~~~bash
echo hello-git > octocat.txt
~~~

####  4.添加跟踪的文件到暂存区(也表示添加了文件快照, 批量添加用git add '*.txt')

~~~bash
git add octocat.txt       # 把文件添加到暂存区, 准备下面提交commit
git reset HEAD <file>...  # 把文件从暂存区移除
~~~

####  5.检查git状态 > [当前分支]变更或新增并未commit, 但是要换分支处理hot-bug, 只能先保存stash中间状态git stash

~~~bash
git status 或 git stash & git checkout [现有分支] ... 或 git checkout master & git checkout -b [新建分支] ...
if git status|grep -q 'clean';then echo clean; else echo dirty; fi ## 获取 git status: clean || dirty
~~~

####  6.提交到本地git仓库(添加了文件版本 -m备注, -am添加变更文件和备注)

~~~bash
git commit -m "Add cute octocat story"       # 本次提交
git reset --soft HEAD^ && git reset HEAD *   # 取消本次提交
~~~

####  7.提交所有更改到本地git仓库(-a添加并处理冲突)

~~~bash
git commit -am '功能#01完成'  # 新增commit
git commit --amend           # 修改最后一次提交
~~~

####  8.查看本地git仓库当前分支的提交记录

~~~bash
git log -3                                # 显示最新的3次提交
git log master --not --remotes=*/master   # 只显示本地提交master分支
git log --branches --not --remotes=origin # 只显示本地提交的所有分支，用于与master分支比较
git log --pretty=format:'%H' -n 1         # git latest commit Id
git log --pretty=format:'%h' -n 1         # git latest commit shortId
if [ "`git describe --tags --abbrev=0 2>/dev/null`" != "" ];then \
git describe --tags --abbrev=0; else git log --pretty=format:'%h' -n 1; fi ## 获取 git tag id
~~~

####  9.准备远程git仓库(##代表git账号: ***@mail.com)

~~~bash
 1)ssh-key的生成(Git-Bash密码为空): 
   ssh-keygen -t rsa -C "##" # 默认配置生成到 ~/.ssh 目录 > id_rsa[密钥], id_rsa.pub[公钥]
   ssh-keygen -t rsa -C 'xx@qq.com' -f ~/.ssh/gitee_id_rsa # 配置多个 SSH-Key 需要指定 file & config
   ssh-keygen -t rsa -C 'xx@mail.com' -f ~/.ssh/github_id_rsa
   #1)在 ~/.ssh 目录下新建一个config文件: 
   # gitee
   Host gitee.com
   HostName gitee.com
   PreferredAuthentications publickey
   IdentityFile ~/.ssh/gitee_id_rsa
   # github
   Host github.com
   HostName github.com
   PreferredAuthentications publickey
   IdentityFile ~/.ssh/github_id_rsa
   #2)用ssh命令分别测试: 
   ssh -T git@gitee.com
   ssh -T git@github.com
 2)##注册到bitbucket.org、github.com，或者自建Git-Server: gogs、Bonobo,  然后上传公钥并检查: ssh git@bitbucket.org
 3)##登陆后, 新建1个空的git仓库***
 4)在以上1-8准备的本地git仓库的目录中执行(添加远程仓库):
    方式一：git remote add origin git@bitbucket.org:##/***.git
    方式二：git remote add origin https://github.com/##/***.git
    方式三：git clone git@bitbucket.org:##/***.git  # clone方式指没有1-8准备的本地git仓库
 5)准备好本地git仓库, 下一步进行推送(远程仓库名origin)
~~~

####  10.准备好本地git仓库后, 推送到远程git仓库(第一次推送时,会在远程新建origin/master分支)

~~~bash
方式一：git push -u [远程仓库名origin] [本地要推送的分支名] # 第一次加-u建立追踪, 让git status可显示本地和远程的不同
方式二：git push -u [远程仓库名origin] --all # 推送本地仓库的所有分支，以后可简写：git push [--all]
git push -u origin master # 远程有更新推送失败时(远程分支保护): 1.先获取git fetch origin处理完再push;2.强制推送git push -f origin master
~~~

####  11.查看远程仓库信息、远程分支与本地建立跟踪关联(远程分支tracked跟踪后可直接用git push|pull)

~~~bash
git remote -v
git remote show [远程仓库名origin] # 远程仓库的查询 git remote -v
git remote rm [远程仓库名origin] # 远程仓库的删除
git remote rename [远程仓库名origin] [远程仓库名origin-new] # 远程仓库重命名
git checkout -b [本地新建分支test] [远程仓库名origin/已有分支test] # 建立跟踪关联(表示跟踪远程分支)
git branch --set-upstream [本地已有分支master] [远程仓库名origin/已有分支master] # 建立跟踪关联
git checkout -b <branch> && git branch --set-upstream-to=origin/<branch> <branch> # 签出分支并建立远程关联
~~~

####  12.获取远程origin仓库master分支所有的变更(最新代码),并下载同步到本地git仓库master

~~~bash
git pull origin master
git pull --all # 获取远程git仓库所有分支的变更
~~~

####  13.比较远程文件与本地文件,哪些文件变化了

~~~bash
git diff HEAD
~~~

####  14.当文件变化或冲突时(git add解决冲突)

~~~bash
git add octofamily/octodog.txt
~~~

####  15.比较暂存区文件版本

~~~bash
git diff --staged
~~~

####  16.重置暂存区文件版本

~~~bash
git reset octofamily/octodog.txt
~~~

####  17.签出文件(完成修改后可添加至新的分支)

~~~bash
git checkout -- octocat.txt
~~~

####  18.新建分支(-c -C 拷贝)

~~~bash
git branch clean_up
~~~

####  19.切换分支(签出新的分支)

~~~bash
git checkout clean_up  # 切换到分支clean_up
git checkout v1.10.1   # 切换到标签v1.10.1
git checkout --orphan branch1 & git rm -rf .  # 新建一个空分支branch1 (--orphan表示没有commit记录的)
git checkout -b branch1 0c304c9 # 从当前分支commit哈希值为0c304c9的节点，分一个新的分支branch1出来，并切换到branch1
~~~

####  20.删除不要的文件或取消修改

~~~bash
git rm '*.txt' # 删除*.txt
git rm -f *    # 强制移除所有  (CMD: rd /q/s [删除目录], BASH: rm -rf [删除目录])
git reset --soft HEAD^       # 回退一次commit,两次HEAD~2
git reset --hard [commit_id] # 回退指定commit(--hard放弃本地改动)
git reset HEAD               # 撤消已暂存的文件，不要本地提交
git clean -nf                # 清除未跟踪文件 &目录: git clean -ndf
git clean -ndfx              # 清除所有未跟踪文件，包括纳入ignore的文件
git stash && git stash drop  # 通过存储暂存区stash，删除暂存区的方法放弃本地修改; 
git stash apply stash@{0}    # 还原暂存区到工作区
git checkout .               # 还原所有修改，不会删除新增的文件
git checkout -- [file]                    # 取消对文件file的修改
git checkout branch|tag|commit -- [file]  # 从仓库取出file覆盖当前分支文件file
~~~

####  21.提交到本地git仓库的当前分支

~~~bash
git commit -m "Remove all the cats"
~~~

####  22.切换分支

~~~bash
git checkout master
git checkout -b [新建分支]
~~~

####  23.合并其他分支(当前不是分支clean_up)

~~~bash
git checkout <name-of-branch>
git merge master          # 合并分支master至当前branch, 可保存日志merge_commit_log（方便跟踪）
git rebase clean_up       # 合并本地分支, 不保存日志（相当于复制一份分支clean_up至当前branch）
git merge clean_up --no-commit --no-ff # 合并本地分支 Create a merge commit
git merge origin/clean_up # 合并远程分支
~~~

####  24.删除其他分支(当前是主分支master)

~~~bash
git branch -d clean_up
git remote rm [远程仓库名origin]/[分支clean_up]
~~~

####  25.加标签-(版本号)

~~~bash
git tag -a v0.1.3 -m "Release Version 0.1.3" # -a 添加, -d 删除
git push origin v0.1.3                 # 推送本地仓库的指定标签到远程仓库origin
git push --tags origin                 # 推送本地仓库的全部标签到远程仓库origin
git push origin :refs/tags/[tag-name]  # 删除远程标签tag-name
~~~

####  26.最后发布

~~~bash
git push --all                         # 推送本地仓库的所有分支和标签
git push origin master                 # 推送本地仓库的主分支master到远程仓库origin/master
~~~

####  27.[push.sh 参考文档](https://github.com/fengyuhetao/shell)

~~~bash
#!/usr/bin/env bash

# 设置异常时退出bash
set -e

# 设置认证授权
git config --local user.name "veggiemonk-bot"
git config --local user.email "info@veggiemonk.ovh"

# 切换至master分支准备提交
git checkout master

echo "在master分支中添加新的内容准备提交."
git add data/*

echo "检查master分支中是否有变更的内容，如果没有就退出bash."
files=$(git diff --cached --numstat | wc -l | tr -d '[:space:]');
[[ $files -eq 0 ]] && echo "nothing to push, exiting..." && exit

echo "在master分支中提交."
git commit -m "Automated update repository metadata [skip ci]"

echo "推送提交的内容至远程仓库的master分支."
git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/veggiemonk/awesome-docker master >/dev/null 2>&1

echo "完成提交master分支."
~~~

----

#### 安装Gitea Server

 [Gitea](https://gitea.io) 是一个自托管Git服务,它类似于GitHub,Bitbucket,Gitlab,最初是基于Gogs上完成,但后来已经分叉并将其命名为Gitea. [`官方安装文档`](https://docs.gitea.io/zh-cn/install-from-binary/)

### Run Gitea service

Download Gitea binary from [download page](https://dl.gitea.io/gitea) first.

```sh
$ wget https://dl.gitea.io/gitea/1.12.4/gitea-1.12.4-linux-amd64 -O gitea
$ chmod +x gitea
```

Add `git` user

```sh
$ useradd -m git
$ cp gitea /home/git/
```

Run `gitea` command as `git` user. default port is `3000`.

```sh
$ su - git
$ ./gitea web
```

### Run Caddy service

Download Caddy binary from [github release page](https://github.com/mholt/caddy/releases).

```sh
$ wget https://github.com/caddyserver/caddy/releases/download/v2.1.1/caddy_2.1.1_linux_amd64.tar.gz -O caddy.tar.gz
$ mkdir caddy && tar -zxf caddy.tar.gz -C caddy
```
Create caddy config file with name as `Caddyfile` and add the following config.

```sh
example.com {
  proxy / 127.0.0.1:3000
}
```

Update Gitea config file `custom/conf/app.ini`.

```ini
[server]
SSH_DOMAIN       = example.com
HTTP_PORT        = 3000
ROOT_URL         = https://example.com
```

### Integrate with Jenkins

Install [Jenkins Gitea Webhook Plugin](https://github.com/jenkinsci/gogs-webhook-plugin).

### Open your browser

https://example.com

