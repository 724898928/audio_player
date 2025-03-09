#!/bin/bash
#rustup target add aarch64-linux-android
#rustup target add armv7-linux-androideabi
#rustup target add x86_64-linux-android
#rustup target add i686-linux-android
export OPENSSL_DIR=/a/programFiles/AndroidSDK/openssl/openssl_arm64_v8a
export OPENSSL_LIB_DIR=${OPENSSL_DIR}/lib
export OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include

#### rust交叉编译android环境配置请参考以下环境配置
#### https://developer.android.com/ndk/guides/other_build_systems?hl=zh-cn
#export PATH=${ANDROID_NDK}/toolchains/llvm/prebuilt/windows-x86_64/bin:$PATH
export TARGET=aarch64-linux-android
export ANDROID_NDK=/a/programFiles/AndroidSDK/Android/Sdk/ndk/29.0.13113456
export TOOLCHAIN=${ANDROID_NDK}/toolchains/llvm/prebuilt/windows-x86_64
export AR=${TOOLCHAIN}/bin/llvm-ar
export CC="${TOOLCHAIN}/bin/clang --target=${TARGET}"
export AS=$CC
export CXX="${TOOLCHAIN}/bin/aarch64-linux-android23-clang++ --target=${TARGET}"
export LD=${TOOLCHAIN}/bin/ld
export RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
export STRIP=${TOOLCHAIN}/bin/llvm-strip

# 支持的 ABI 列表
#ABIS=("aarch64-linux-android" "armv7-linux-androideabi" "x86_64-linux-android" "i686-linux-android")
ABIS=("aarch64-linux-android")

# 为每个 ABI 编译
for abi in "${ABIS[@]}"; do
  echo "Building for $abi..."
  cargo build --target $abi --release
done

# 复制 .so 文件到 Android 项目的 jniLibs
TARGET_DIR="$(pwd)/target"
ANDROID_PROJECT_JNI_LIBS="../android/app/src/main/jniLibs"

mkdir -p $ANDROID_PROJECT_JNI_LIBS

for abi in "${ABIS[@]}"; do
  ABI_DIR=""
  case $abi in
    "aarch64-linux-android") ABI_DIR="arm64-v8a" ;;
    "armv7-linux-androideabi") ABI_DIR="armeabi-v7a" ;;
    "x86_64-linux-android") ABI_DIR="x86_64" ;;
    "i686-linux-android") ABI_DIR="x86" ;;
  esac

  mkdir -p "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR"
  cp "$TARGET_DIR/$abi/release/rust_lib_audio_player.so" "$ANDROID_PROJECT_JNI_LIBS/$ABI_DIR/"
done

echo "Done! .so files copied to Android project."