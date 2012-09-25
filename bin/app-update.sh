#!/bin/bash -e
# cd /var/app/sovellus/
# wget https://github.com/opinsys/vagrant-tools/raw/master/bin/app-update.sh -O app-update.sh && bash -e app-update.sh


cd $(git rev-parse --show-toplevel)

if [[ ! $(cat .git/HEAD) =~ "ref: refs/heads/master"  ]]; then
    echo "You are not on the master branch?"
    exit 1
fi

APP=$(basename $(pwd))

echo "Fetching changes..."
git fetch origin

git branch -r

read -p "Merge from branch?> " BRANCH

[ -z "$BRANCH" ] && exit 1

git diff master..$BRANCH

builtin read -p "Merge above and update? (y/N)> " MERGE
if [ "$MERGE" != "y" ]; then
    echo "Update canceled"
    exit 1
fi

git merge $BRANCH
[ -f Makefile ] && make


echo
sudo restart $APP
echo

echo
TAG_NAME="update-$(date +%Y-%m-%d_%H-%M)"
echo "Creating tag $TAG_NAME"
git tag -a $TAG_NAME -m "Production update from $BRANCH on $(date)"
echo

echo "Upstart log: sudo tail -f /var/log/upstart/$APP.log"
echo "If ok push changes and tags"
echo "git push origin master:master"
echo "git push --tags origin"




