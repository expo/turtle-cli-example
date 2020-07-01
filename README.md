# Turtle CLI usage example

This is just a simple Expo app (generated with `expo init` command, `expo-template-blank` template) that uses [CircleCI](https://circleci.com) and [Travis CI](https://travis-ci.org/) to build Expo standalone apps (for Android and iOS). It demonstrates how to leverage [turtle-cli](https://www.npmjs.com/package/turtle-cli) to build `.apk`/`.aab`/`.ipa` files without the need to use the Expo servers.

## Issues

If you have problems with the code in this repository, please file issues & bug reports at https://github.com/expo/turtle/issues. Thanks!

## CI pipelines

The CI pipelines consist of two stages. In the first stage we publish the Expo project to the Expo servers using the `expo publish` command (see [Publishing](https://docs.expo.io/versions/latest/workflow/publishing) to learn more, if you would like to host your app on your own server, [see this guide](https://docs.expo.io/versions/latest/distribution/hosting-your-app)). In the second stage we build application binaries for:
- Google Play Store - `.apk` and `.aab` files
- Apple App Store - `.ipa` file
- iOS simulator - in `.tar.gz` archive

## Providing credentials for your app

In order to successfully reuse CI configuration files, you have to set some environment variables first:
- common for all jobs (you don't need to set these if you pass the `--public-url` parameter to the build command)
  * `EXPO_USERNAME` - your Expo account username
  * `EXPO_PASSWORD` - your Expo account password
- Android-specific. You can obtain these values from Expo servers
by running `expo fetch:android:keystore` in your Expo project's directory.
  * `EXPO_ANDROID_KEYSTORE_BASE64` - **base64-encoded** Android keystore
  * `EXPO_ANDROID_KEYSTORE_ALIAS` - Android keystore alias
  * `EXPO_ANDROID_KEYSTORE_PASSWORD` - Android keystore password
  * `EXPO_ANDROID_KEY_PASSWORD` - Android key password
- iOS-specific. You can obtain these values from Expo servers
by running `expo fetch:ios:certs` in your Expo project's directory.
  * `EXPO_APPLE_TEAM_ID` - Apple Team ID - (a 10-character string like "Q2DBWS92CA")
  * `EXPO_IOS_DIST_P12_BASE64` - **base64-encoded** iOS Distribution Certificate
  * `EXPO_IOS_DIST_P12_PASSWORD` - iOS Distribution Certificate password
  * `EXPO_IOS_PROVISIONING_PROFILE_BASE64` - **base64-encoded** iOS Provisioning Profile

On macOS, you can base64-encode the contents of a file and copy the string to
the clipboard by running `base64 some-file | pbcopy` in a terminal.

## CircleCI

[![CircleCI](https://circleci.com/gh/expo/turtle-cli-example.svg?style=svg)](https://circleci.com/gh/expo/turtle-cli-example)

CircleCI configuration file: [.circleci/config.yml](.circleci/config.yml)
- [See how to set environment variables.](https://circleci.com/docs/2.0/env-vars/#setting-an-environment-variable-in-a-project)
You'll need to define all of the environment variables described above.
- The APK and IPA files are uploaded as build artifacts stored by CircleCI.

### Upgrading your app

When you upgrade the Expo SDK version in your app, you should also modify the following section in `.circleci/config.yml` and update the `turtle-cli` version to the latest (the update is required to get the support for the new Expo SDK version!):
```yaml
android:
  # WARNING: medium (default) seems not to be enough for Turtle
  resource_class: xlarge
  docker:
    # https://github.com/expo/expo-turtle-android
    - image: dsokal/expo-turtle-android
  working_directory: ~/expo-project
  environment:
    EXPO_SDK_VERSION: 37.0.0 # << REPLACE WITH THE EXPO SDK VERSION OF YOUR APP
    TURTLE_VERSION: 0.16.2   # << REPLACE THE LATEST TURTLE-CLI VERSION HERE
    PLATFORM: android
    YARN_CACHE_FOLDER: ~/yarn_cache

ios:
  macos:
    xcode: 10.1.0
  working_directory: ~/expo-project
  environment:
    EXPO_SDK_VERSION: 37.0.0 # << REPLACE WITH THE EXPO SDK VERSION OF YOUR APP
    TURTLE_VERSION: 0.16.2   # << REPLACE THE LATEST TURTLE-CLI VERSION HERE
    PLATFORM: ios
    YARN_CACHE_FOLDER: /Users/distiller/yarn_cache
    HOMEBREW_NO_AUTO_UPDATE: 1
```

### Docker image for Android builds

The Android executor uses `dsokal/expo-turtle-android` Docker Image. The image is based on `circleci/node:12.13.1` and has JDK 8 installed. See the [expo/expo-turtle-android](https://github.com/expo/expo-turtle-android) repository to learn more.

## Travis CI

[![Build Status](https://travis-ci.org/expo/turtle-cli-example.svg?branch=master)](https://travis-ci.org/expo/turtle-cli-example)

Travis CI configuration file: [.travis.yml](.travis.yml)
- [See how to set environment variables.](https://docs.travis-ci.com/user/environment-variables/)
You'll need to define all of the environment variables described above.
- The APK and IPA files are build artifacts uploaded to your own AWS S3 bucket.
You'll have to set additional environment variables:
  * `AWS_ACCESS_KEY_ID` - your AWS Access Key
  * `AWS_SECRET_ACCESS_KEY` - your AWS Secret Access Key
  * `AWS_BUCKET` - name of the bucket
  * `AWS_REGION` - region of the bucket

### Upgrading your app

When you upgrade the Expo SDK version in your app, you should also modify the following section in `.travis.yml`:
```yaml
env:
  global:
    - EXPO_SDK_VERSION="37.0.0"  # << REPLACE WITH THE EXPO SDK VERSION OF YOUR APP
    - TURTLE_VERSION="0.16.2"    # << REPLACE THE LATEST TURTLE-CLI VERSION HERE
    - NODE_VERSION="12.13.1"
    - YARN_VERSION="1.21.1"
```

## Learn more

See [Building Standalone Apps on Your CI](https://docs.expo.io/versions/latest/distribution/turtle-cli) to learn more.
