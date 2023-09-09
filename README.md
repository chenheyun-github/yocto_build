# yocto_build
如果已经完整同步工程，使用该脚本可配置工程：
1.source setup/scripts/build/setup.sh -m qemuarm64 -b ./ --


备注：
1.repo push
 you can Switching remote URLs from HTTPS to SSH
 a/
     $ git remote -v
    > origin  https://github.com/OWNER/REPOSITORY.git (fetch)
    > origin  https://github.com/OWNER/REPOSITORY.git (push)
  b/Change your remote's URL from HTTPS to SSH with the git remote set-url command.
    git remote set-url origin git@github.com:OWNER/REPOSITORY.git
