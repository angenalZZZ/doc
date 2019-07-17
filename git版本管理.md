
# **[安装Git for Mac & Linux](https://gist.github.com/derhuerst/1b15ff4652a867391f03)**、[安装Git for Windows](https://github.com/git-for-windows/git/releases)

#### Global Config
~~~bash
git config --global user.name                 # 查询全局git用户配置
git config --global user.name "yangzhou"      # 修改全局git用户配置
git config --global user.email "angenal@hotmail.com"
git config --global http.postBuffer 524288000 # 上传文件大小限制500M=1024*1024*500(默认100M)
git config --global http.sslVerify "false"    # 关闭ssl验证(网络异常)
git config --global http.lowSpeedLimit 0      # 下载文件限制
git config --global http.lowSpeedTime 999999  # 下载文件时速

git clone --depth=1 https://***/***/***.git   # 下载失败时，首先浅层clone..
git fetch --unshallow                         # ..然后更新远程库到本地,或者使用SSH进行下载.
~~

#### Create a new repository on the command line, push into github.com
~~~bash
echo "# CSharpOpen" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin https://github.com/angenal/CSharpOpen.git
git push -u origin master
~~~

#### Push an existing repository from the command line.
~~~bash
git remote add origin https://github.com/angenal/CSharpOpen.git
git push -u origin master
~~~

#### Contributing and PR for your new feature.
1. Fork it
2. Download your fork to your PC (`git clone https://github.com/your_username/feature && cd feature`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Make changes and add them (`git add .`)
5. Commit your changes (`git commit -m 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new pull request


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
~~~

####  6.提交到本地git仓库(添加了文件版本 -m备注, -am添加变更文件和备注)

~~~bash
git commit -m "Add cute octocat story"
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
~~~

####  9.准备远程git仓库(##代表git账号: ***@mail.com)

~~~bash
 1)ssh-key的生成(Git-Bash密码为空): ssh-keygen -t rsa -C "##" , 默认生成到.ssh目录: id_rsa[密钥], id_rsa.pub[公钥]
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
git remote show [远程仓库名origin] # 远程仓库的查询 git remote -v
git remote rm [远程仓库名origin] # 远程仓库的删除
git remote rename [远程仓库名origin] [远程仓库名origin2] # 远程仓库重命名
git branch --set-upstream [本地已有分支master] [远程仓库名origin/已有分支master] # 建立跟踪关联
git checkout -b [本地新建分支test] [远程仓库名origin/已有分支test] # 建立跟踪关联(表示跟踪远程分支)
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
git merge clean_up        # 合并本地分支
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

