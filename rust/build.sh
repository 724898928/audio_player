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
  export OPENSSL_DIR=A:/programFiles/AndroidSDK/openssl/openssl_${key}
  export OPENSSL_LIB_DIR=${OPENSSL_DIR}/lib
  export OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include

  export ANDROID_NDK=A:/programFiles/AndroidSDK/Android/Sdk/ndk/29.0.13113456
  export ANDROID_NDK_HOME=A:/programFiles/AndroidSDK/Android/Sdk/ndk/29.0.13113456
  export TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/windows-x86_64
  export PATH=${TOOLCHAIN}/bin:$PATH

  export AR=${TOOLCHAIN}/bin/llvm-ar
  export linker="${TOOLCHAIN}/bin/${ABIS[$key]}29-clang.cmd --target=${ABIS[$key]}"
  export CC="${TOOLCHAIN}/bin/${ABIS[$key]}29-clang++"
  # 一般配置 CC, AR 即可，如出现问题再将以下3条加上：
  export TARGET_CC=$CC
  export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$CC
  export CARGO_TARGET_AARCH64_LINUX_ANDROID_AR=$AR
  export AS=$CC
  export CXX="${TOOLCHAIN}/bin/${ABIS[$key]}29-clang++ --target=${ABIS[$key]}"
  export LD=${TOOLCHAIN}/bin/ld
  export RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
  export STRIP=${TOOLCHAIN}/bin/llvm-strip
  ###需要修改  rust target armv7-linux-androideabi => android target armv7a-linux-androideabi
  if [ $key == "arm" ];then
    echo "*********** cargo build arm ********* "
    cargo build --target ${ABIS[$key]} --release \
      --config "target.${ABIS[$key]}.linker=\"$ANDROID_NDK/toolchains/llvm/prebuilt/windows-x86_64/bin/armv7a-linux-androideabi29-clang.cmd\"" \
      --config "target.${ABIS[$key]}.rustflags=\"-l c++_shared\""
  else
    cargo build --target ${ABIS[$key]} --release \
      --config "target.${ABIS[$key]}.linker=\"$ANDROID_NDK/toolchains/llvm/prebuilt/windows-x86_64/bin/${ABIS[$key]}29-clang.cmd\"" \
      --config "target.${ABIS[$key]}.rustflags=\"-l c++_shared\""
  fi


#  ABI_DIR=""
#  case $key in
#  "arm64") ABI_DIR="arm64-v8a" ;;
#  "arm") ABI_DIR="armeabi-v7a" ;;
#  "x86_64") ABI_DIR="x86_64" ;;
#  "x86") ABI_DIR="x86" ;;
#  esac

  mkdir -p "$ANDROID_PROJECT_JNI_LIBS/${myMap[$key]}"
  cp "$TARGET_DIR/${ABIS[$key]}/${flag}/librust_lib_audio_player.so" "$ANDROID_PROJECT_JNI_LIBS/${myMap[$key]}/"
done
