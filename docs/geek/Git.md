# 一个RD的Git工作流

Joker是一名IT普通开发者，入职公司第一天就要拉取代码仓库

# 拉取别人的仓库

git clone 
git clone --depth=1

# 自己创建仓库

git init
git init --bare

# 修改、添加、提交以及这个过程中每一步的撤销

git add .
git checkout -- 

git commit -m 'message'
git reset --hard HEAD

# 添加远程仓库

git add origin url
git fetch origin

# 推送并跟踪分支包含tag

git push --tags -u origin master:master
git push --force 

# 创建分支

git checkout -b new-branch

# 切换分支

git checkout branch_name
git checkout -

# 修改本地分支名称

git brach -m old_branch new_branch

# 查看本地分支和远程分支对应关系

git branch -vv

# 配置本地shell提示显示分支名称

// TODO

# 删除远程分支

git push origin :branch_name

# 回滚

git revert

# 修改提交记录

git commit --amend 

git rebase -i HEAD^^2

# 取回远程仓库最新的信息

git fetch 

# 查找远程仓库的分支信息

git branch -r | grep keywork

# .gitignore

# .gitmodules

# hooks

规范提示记录实践

# 对比修改

git diff

# 查看git日志

git log


