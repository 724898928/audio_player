# Rust 交叉工具链安装
rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi

# 查看已安装 结尾带(Installed)
rustup target list

# 查看工具链和编译目标：
rustup toolchain list
rustup target list

# 编译android库
cargo build --target aarch64-linux-android --release
cargo build --target armv7-linux-androideabi --release