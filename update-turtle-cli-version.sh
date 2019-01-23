#!/bin/bash

export TURTLE_VERSION_NEW=`npm show turtle-cli version`
envsub --env TURTLE_VERSION_NEW .circleci/config.template.yml .circleci/config.yml
envsub --env TURTLE_VERSION_NEW README.template.md README.md
envsub --env TURTLE_VERSION_NEW .travis.template.yml .travis.yml

git add .circleci/config.yml README.md .travis.yml
git commit -m "update to turtle-cli@$TURTLE_VERSION_NEW"
