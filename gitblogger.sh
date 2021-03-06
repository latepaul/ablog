#!/bin/sh
#
# gitblogger.sh  create new post for 'git blog'
#                What this does is touch a file, add it, commit it and then
#                the commit message is the blog post

CTEMPLATE=/tmp/commit.$$.template
export EDITOR=`which vi`

if [ -f FILE ]
then
    DO_PULL=1
else
    echo "There's no FILE here, i.e. blog is empty. If you've updated it from elsewhere"
    echo "then a git pull will update it here. If not, then git pull will fail"
    read -p "Run git pull (y/N)" ans
    if [ "$ans" = "y" ]
    then
        DO_PULL=1
    fi
fi

if [ $DO_PULL -eq 1 ]
then
    git pull 
    if [ $? -ne 0 ]
    then
        echo "Failed git pull"
        exit 1
    fi
fi

if [ ! -f FILE ]
then
    NUM=-1
else
    NUM=`cat FILE`
fi

NUM=`expr $NUM + 1`
echo $NUM > FILE

echo "" > $CTEMPLATE
echo "" >> $CTEMPLATE
echo "($NUM)" >> $CTEMPLATE
git add FILE $0
git commit -t $CTEMPLATE

if [ $? -eq 0 ]
then
    git push
    tput clear
    echo "+------------------------------------------------------------------------------+ "
    git log -1
    echo "+------------------------------------------------------------------------------+ "
    echo " "
else
    git reset FILE
    git checkout FILE
fi
rm -f $CTEMPLATE
