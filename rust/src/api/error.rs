
use std::sync::mpsc::SendError;

use rodio;
#[cfg(not(target_os = "android"))]
use crate::music_service::PlayerCommand;
#[cfg(target_os = "android")]
use crate::android_service::PlayerCommand;

#[derive(Debug)]
pub enum PlayerError {
    IoError(std::io::Error),
    DecodeError(rodio::decoder::DecoderError),
    PlayeError(rodio::PlayError),
    RodioError(rodio::StreamError),
    SenderError(SendError<PlayerCommand>),
    ReqError(reqwest::Error),
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

impl From<reqwest::Error> for PlayerError {
    fn from(err: reqwest::Error) -> Self {
        PlayerError::ReqError(err)
    }
}


impl std::error::Error for PlayerError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            PlayerError::IoError(err) => Some(err),
            PlayerError::DecodeError(err) => Some(err),
            PlayerError::PlayeError(err) => Some(err),
            PlayerError::RodioError(err) => Some(err),
            PlayerError::SenderError(err) => Some(err),
            PlayerError::ReqError(err) => Some(err),
        }
    }
}

impl std::fmt::Display for PlayerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "PlayerError: {}", self)
    }
}