# Rust 交叉工具链安装
安装交叉编译组件

在CMD或者PowerShell执行下面的代码，来支持各平台的编译，依然需要等待几分钟。其中，各平台与Android NDK filter的映射关系如下：
 aarch64-linux-android 对应 arm64-v8a  
 armv7-linux-androideabi 对应 armeabi-v7a 
 i686-linux-android 对应 x86

rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi

# 查看已安装 结尾带(Installed)
rustup target list

# 查看工具链和编译目标：
rustup toolchain list
rustup target list

# 安装编译工具
cargo install cargo-ndk

# 编译android库
cargo build --target aarch64-linux-android --release
cargo build --target armv7-linux-androideabi --release


cargo ndk -t armeabi-v7a -t arm64-v8a build --release