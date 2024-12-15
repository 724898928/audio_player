
use rodio;
#[derive(Debug)]
pub enum PlayerError {
    IoError(std::io::Error),
    DecodeError(rodio::decoder::DecoderError),
    PlayeError(rodio::PlayError)
}

impl From<std::io::Error> for PlayerError {
    fn from(err: std::io::Error) -> Self {
        PlayerError::IoError(err)
    }
}

impl From<rodio::decoder::DecoderError> for PlayerError {
    fn from(err: rodio::decoder::DecoderError) -> Self {
        PlayerError::DecodeError(err)
    }
}

impl From<rodio::PlayError> for PlayerError {
    fn from(err: rodio::PlayError) -> Self {
        PlayerError::PlayeError(err)
    }
}