#!/bin/sh

set -e

rm -rf bundle/*
git rm --cached bundle/*
rm -rf .git/modules/bundle

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
    while read path_key path
    do
        url_key=$(echo $path_key | sed 's/\.path/.url/')
        url=$(git config -f .gitmodules --get "$url_key")
        git submodule add $url $path
    done

git update-index --assume-unchanged bundle
