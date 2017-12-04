#!/bin/bash

set -e

echo "after this operation the local master branch is corrupted"

# wisnuc-bootstrap-linux-x64
# wisnuc-bootstrap-linux-x64-sha256 
# wisnuc-bootstrap-linux-a64
# wisnuc-bootstrap-linux-a64-sha256 

rm -rf app

# generate output
node_modules/.bin/nexe src/app.js

# checksum
openssl dgst -sha256 app | awk '{print $2}' > wisnuc-bootstrap-linux-x64-sha256

# rename
mv app wisnuc-bootstrap-linux-x64

# dup gitignore
cp .gitignore.release .gitignore

# reset 
rm -rf .git
git init
git add .
git commit -a -m 'reinit'

# set remote and switch to release branch
git remote add origin https://github.com/wisnuc/wisnuc-bootstrap
git checkout -b staging
git push --force --set-upstream origin staging

