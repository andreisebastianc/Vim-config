#!/bin/sh

set -e

DIR='bundle'

if [ "$(ls -A $DIR)" ]; then
    rm -rf bundle/*
    git rm --cached bundle/*
    rm -rf .git/modules/bundle
fi

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
while read path_key path
do
    url_key=$(echo $path_key | sed 's/\.path/.url/')
    url=$(git config -f .gitmodules --get "$url_key")
    git submodule add $url $path
done

cd bundle/vimproc
make -f make_unix.mak
