#!/bin/bash

TAG=${1:-latest}

export TURTLE_VERSION_NEW=`npm show turtle-cli@$TAG version`
export APP_EXPO_SDK_VERSION="37.0.0"
envsubst '${TURTLE_VERSION_NEW} ${APP_EXPO_SDK_VERSION}' < .circleci/config.template.yml > .circleci/config.yml
envsubst '${TURTLE_VERSION_NEW} ${APP_EXPO_SDK_VERSION}' < README.template.md > README.md
envsubst '${TURTLE_VERSION_NEW} ${APP_EXPO_SDK_VERSION}' < .travis.template.yml > .travis.yml

git add .circleci/config.yml README.md .travis.yml
git commit -m "update to turtle-cli@$TURTLE_VERSION_NEW"
