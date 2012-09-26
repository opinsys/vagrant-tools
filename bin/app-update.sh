#!/bin/bash -e
# cd /var/app/sovellus/
# wget https://github.com/opinsys/vagrant-tools/raw/master/bin/app-update.sh -O app-update.sh && bash -e app-update.sh


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

echo
read -p "Merge above and update? (y/N)> " MERGE
if [ "$MERGE" != "y" ]; then
    echo "Merge&Update canceled"
    exit 1
fi

git merge $BRANCH

[ -f Makefile ] && make

echo
echo "Restarting $APP with Upstart..."
sudo restart $APP


echo
read -p "Tag update and push it to origin/master? (y/N)> " PUSH
if [ "$PUSH" == "y" ]; then
    echo
    TAG_NAME="update-$(date +%Y-%m-%d_%H-%M)"
    echo "Creating tag $TAG_NAME"
    git tag -a $TAG_NAME -m "Production update from $BRANCH on $(date)"
    git push origin master:master
    git push --tags origin
fi
