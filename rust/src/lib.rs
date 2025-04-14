// 其他平台的默认模块
#[cfg(not(target_os = "android"))]
pub mod api;
// 其他平台的默认模块
#[cfg(not(target_os = "android"))]
pub mod music_service;
// 其他平台的默认模块
#[cfg(not(target_os = "android"))]
pub mod frb_generated;

#[cfg(target_os = "android")]
#[path = "android.rs"]
pub mod android;

