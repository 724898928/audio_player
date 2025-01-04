#! bin/bash
export ANDROID_NDK=A:\\programFiles\\AndroidSDK\\Android\\Sdk\\ndk\\28.0.12674087

export CC=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang++
export AR=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar

# 一般配置 CC, AR 即可，如出现问题再将以下3条加上：
export TARGET_CC=$CC
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$CC
export CARGO_TARGET_AARCH64_LINUX_ANDROID_AR=$AR