
use error::PlayerError;

pub mod error;
#[cfg(not(target_os = "android"))]
pub mod simple;

pub mod utils;
pub use rodio::PlayError;


pub type Result<T> = std::result::Result<T, PlayerError>;
