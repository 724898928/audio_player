
use std::sync::mpsc::SendError;

use rodio;

use crate::music_service::PlayerCommand;

#[derive(Debug)]
pub enum PlayerError {
    IoError(std::io::Error),
    DecodeError(rodio::decoder::DecoderError),
    PlayeError(rodio::PlayError),
    RodioError(rodio::StreamError),
    SenderError(SendError<PlayerCommand>)
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

impl From<rodio::StreamError> for PlayerError {
    fn from(err: rodio::StreamError) -> Self {
        PlayerError::RodioError(err)
    }
}

impl  From<SendError<PlayerCommand>> for PlayerError {
    fn from(value: SendError<PlayerCommand>) -> Self {
        PlayerError::SenderError(value) 
       }
}