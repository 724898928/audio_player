#!/bin/bash
export ANDROID_NDK=/a/programFiles/AndroidSDK/Android/Sdk/ndk/28.0.12674087

export CC=${ANDROID_NDK}/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android21-clang++
export AR=$ANDROID_NDK/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-ar
# 支持的 ABI 列表
ABIS=("aarch64-linux-android" "armv7-linux-androideabi" "x86_64-linux-android" "i686-linux-android")

# 为每个 ABI 编译
for abi in "${ABIS[@]}"; do
  echo "Building for $abi..."
  cargo build --target $abi --release
done

# 复制 .so 文件到 Android 项目的 jniLibs
TARGET_DIR="$(pwd)/target"
ANDROID_PROJECT_JNI_LIBS="../android-app/app/src/main/jniLibs"

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