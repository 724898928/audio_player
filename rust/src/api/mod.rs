
use error::PlayerError;

pub mod error;
pub mod simple;
pub mod utils;
pub use rodio::PlayError;


pub type Result<T> = std::result::Result<T, PlayerError>;
