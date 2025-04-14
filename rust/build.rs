use std::error::Error;
use std::path::PathBuf;
use serde::Deserialize;
use config::Config as cfg;
use std::env;
extern crate dotenv;

use dotenv::dotenv;
#[derive(Debug, Deserialize)]
pub struct Config {
    pub openssl: OpenSSLConfig,
    pub android: AndroidConfig,
    pub target: TargetConfig,
    pub toolchain: ToolchainConfig,
    #[serde(rename = "flags")]
    pub build_flags: BuildFlags,
}

#[derive(Debug, Deserialize)]
pub struct OpenSSLConfig {
    pub dir: PathBuf,
    pub lib_dir: PathBuf,
    pub include_dir: PathBuf,
}

#[derive(Debug, Deserialize)]
pub struct AndroidConfig {
    pub ndk: NdkConfig,
}

#[derive(Debug, Deserialize)]
pub struct NdkConfig {
    pub path: PathBuf,
    pub toolchain: PathBuf,
}

#[derive(Debug, Deserialize)]
pub struct TargetConfig {
    pub arch: String,
    pub os: String,
    pub abi: String,
    pub triple: String,
}

#[derive(Debug, Deserialize)]
pub struct ToolchainConfig {
    pub ar: String,
    pub cc: String,
    #[serde(rename = "as")]
    pub as_: String,
    pub cxx: String,
    pub ld: String,
    pub ranlib: String,
    pub strip: String,
}

#[derive(Debug, Deserialize)]
pub struct BuildFlags {
    pub common: Vec<String>,
}
pub fn load_config() -> Result<Config, Box<dyn Error>> {
    let run_mode = env::var("RUN_MODE").unwrap_or_else(|_| "cross-compile/android".into());

    cfg::builder()
        .add_source(config::File::with_name(".cargo/base"))
        .add_source(config::File::with_name(&format!(".cargo/{}", run_mode)).required(true))
        .add_source(config::Environment::with_prefix("APP").separator("__"))
        .build()?
        .try_deserialize().map(|x|{ println!("{:#?}",&x);x})
        .map_err(Into::into)
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 初始化配置, 加载.env配置
     dotenv().ok();
     println!("Target OS: {}", std::env::consts::OS); // 输出：androids
    // let openssl_dir = env::var("OPENSSL_DIR").unwrap();
   //  load_config().map(|config|set_env_vars(&config)).unwrap();
    Ok(())
}

// 在 build.rs 中设置环境变量
fn set_env_vars(config: &Config) {
    println!("set_env_vars config:{:#?}",&config);
    // OpenSSL 配置
    println!("cargo:rustc-env=OPENSSL_DIR={}", config.openssl.dir.display());
    println!("cargo:rustc-env=OPENSSL_LIB_DIR={}", config.openssl.lib_dir.display());
    println!("cargo:rustc-env=OPENSSL_INCLUDE_DIR={}", config.openssl.include_dir.display());

    // 工具链配置
    println!("cargo:rustc-env=AR={}", config.toolchain.ar);
    println!("cargo:rustc-env=CC={}", config.toolchain.cc);
    println!("cargo:rustc-env=CXX={}", config.toolchain.cxx);
    println!("cargo:rustc-env=LD={}", config.toolchain.ld);
    println!("cargo:rustc-env=RANLIB={}", config.toolchain.ranlib);
    println!("cargo:rustc-env=STRIP={}", config.toolchain.strip);
}