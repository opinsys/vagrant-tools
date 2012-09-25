#!/bin/bash -e
# cd /var/app/sovellus/
# wget https://github.com/opinsys/vagrant-tools/raw/master/bin/app-update.sh -O app-update.sh && bash -e app-update.sh


cd $(git rev-parse --show-toplevel)

if [[ ! $(cat .git/HEAD) =~ "ref: refs/heads/master"  ]]; then
    echo "You are not on the master branch?"
    exit 1
fi

APP=$(basename $(pwd))

git fetch origin

git branch -r

read -p "Branch?> " BRANCH

[ -z "$BRANCH" ] && exit 1

git diff master..$BRANCH

builtin read -p "Merge above and update? (y/n)> " MERGE
if [ "$MERGE" != "y" ]; then
    echo "Merge canceled"
    exit 1
fi

git merge $BRANCH
make
sudo restart $APP
sudo tail -f /var/log/upstart/$APP.log ; echo && echo "Push master if ok: git push origin master:master"
