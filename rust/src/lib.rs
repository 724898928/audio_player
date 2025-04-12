pub mod api;
pub mod music_service;
pub mod frb_generated;
#[cfg(target_os = "android")]
#[path = "android.rs"]
pub mod android;

