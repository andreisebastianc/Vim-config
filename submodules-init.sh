#!/bin/sh

set -e

DIR='bundle'

if [ -d $DIR ]; then
    rm -rf $DIR
    git rm -r --cached $DIR
    rm -rf './.git/modules/'$DIR
fi

mkdir $DIR

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
while read path_key path
do
    url_key=$(echo $path_key | sed 's/\.path/.url/')
    url=$(git config -f .gitmodules --get "$url_key")
    git submodule add -f $url $path
done

#additional setup for plugins

cd $DIR'/vimproc'
make -f make_unix.mak
