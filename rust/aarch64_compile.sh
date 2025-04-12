#!/bin/bash
#rustup target add aarch64-linux-android
#rustup target add armv7-linux-androideabi
#rustup target add x86_64-linux-android
#rustup target add i686-linux-android
export OPENSSL_DIR=/a/programFiles/AndroidSDK/openssl/openssl_arm64
export OPENSSL_LIB_DIR=${OPENSSL_DIR}/lib
export OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include
#
export AARCH64_LINUX_ANDROID_OPENSSL_DIR=/a/programFiles/AndroidSDK/openssl/openssl_arm64
export AARCH64_LINUX_ANDROID_OPENSSL_LIB_DIR=${OPENSSL_DIR}/lib
export AARCH64_LINUX_ANDROID_OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include

#### rust交叉编译android环境配置请参考以下环境配置
#### https://developer.android.com/ndk/guides/other_build_systems?hl=zh-cn
export ANDROID_NDK=/a/programFiles/AndroidSDK/Android/Sdk/ndk/29.0.13113456
export ANDROID_NDK_HOME=/a/programFiles/AndroidSDK/Android/Sdk/ndk/29.0.13113456
export TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/windows-x86_64
export PATH=${TOOLCHAIN}/bin:$PATH
export TARGET=aarch64-linux-android
export AR=${TOOLCHAIN}/bin/llvm-ar
export linker="${TOOLCHAIN}/bin/aarch64-linux-android30-clang++ --target=${TARGET}"
export CC="${TOOLCHAIN}/bin/aarch64-linux-android30-clang++"
# 一般配置 CC, AR 即可，如出现问题再将以下3条加上：
export TARGET_CC=$CC
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$CC
export CARGO_TARGET_AARCH64_LINUX_ANDROID_AR=$AR
#export AS=$CC
#export CXX="${TOOLCHAIN}/bin/aarch64-linux-android30-clang++ --target=${TARGET}"
#export LD=${TOOLCHAIN}/bin/ld
#export RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
#export STRIP=${TOOLCHAIN}/bin/llvm-strip

abi="aarch64-linux-android"
TARGET_DIR="$(pwd)/target"
cargo build --target $abi --release
#    --config "target.$abi.linker=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/$abi-clang" \
#    --config "target.$abi.rustflags=-l c++_shared"

# llvm-strip "$TARGET_DIR/$abi/release/librust_lib_audio_player.so"
ANDROID_PROJECT_JNI_LIBS="../android/app/src/main/jniLibs"
ABI_DIR="arm64-v8a"
mkdir -p $ANDROID_PROJECT_JNI_LIBS
mkdir -p "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR"
cp "$TARGET_DIR/$abi/release/librust_lib_audio_player.so" "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR/"
echo "Done! .so files copied to Android project."