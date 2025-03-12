#!/bin/bash
flag=${1:-release}
# 定义和初始化 Map
declare -A myMap=(["arm64"]="arm64-v8a" ["arm"]="armeabi-v7a" ["x86_64"]="x86_64" ["x86"]="x86")
declare -A ABIS=(["arm64"]="aarch64-linux-android" ["arm"]="armv7-linux-androideabi" ["x86_64"]="x86_64-linux-android" ["x86"]="i686-linux-android")
TARGET_DIR="$(pwd)/target"
ANDROID_PROJECT_JNI_LIBS="../android/app/src/main/jniLibs"
mkdir -p $ANDROID_PROJECT_JNI_LIBS
# shellcheck disable=SC2068
for key in ${!myMap[@]}; do
    echo "key: $key, value: ${myMap[$key]}"
    export OPENSSL_DIR=/a/programFiles/AndroidSDK/openssl/openssl_${key}
    export OPENSSL_LIB_DIR=${OPENSSL_DIR}/lib
    export OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include
    cargo ndk -t ${myMap[$key]} build --${flag}
  ABI_DIR=""

  case $key in
    "arm64") ABI_DIR="arm64-v8a" ;;
    "arm") ABI_DIR="armeabi-v7a" ;;
    "x86_64") ABI_DIR="x86_64" ;;
    "x86") ABI_DIR="x86" ;;
  esac

    mkdir -p "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR"
    cp "$TARGET_DIR/${ABIS[$key]}/${flag}/librust_lib_audio_player.so" "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR/"
done