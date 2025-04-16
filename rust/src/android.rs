use anyhow::{Error, Result};
use jni::{
    objects::{JClass, JList, JObject, JObjectArray, JString, JValue},
    sys::{jfloat, jint, jobject, jvalue,jobjectArray}, JNIEnv
};
use symphonia::core::formats::util;
use std::fmt::Display;
use jni::sys::jstring;
use crate::{android_service::{PlayMode, Player_instance}, api::utils};
use log::{Level, LevelFilter};
use android_logger::{Config,FilterBuilder};

// 初始化 Android 日志记录器
fn init_android_logger(tag: &str) {
    let filter = FilterBuilder::new()
        .parse(Level::Debug.to_string().as_str())  // 设置日志级别（Debug/Info/Error等）
        .build();

    android_logger::init_once(
        Config::default()
            .with_tag(tag)  // 设置日志标签（对应 Logcat 的 TAG）
            .with_filter(filter)
    );
}

// JNI 入口函数示例
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_nativeInit(
    env: JNIEnv,
    _class: jni::objects::JClass,
) {
    // 初始化日志记录器（标签设置为 "RustNative"）
    init_android_logger("RustNative");
    // 打印日志示例
    info!("Rust logger initialized!");
    error!("This is an error log from Rust");
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_hello<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    input: JString<'a>,
) -> JString<'a> {
    let input: String = env
        .get_string(&input)
        .expect("Couldn't get java string!")
        .into();
    let output = env
    .new_string(format!("Hello, {}!", input))
    .expect("Couldn't create java string!");
    output
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_add<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    a: jint,
    b: jint,
    callback: JObject,
) -> jint {
    let a = a as i32;
    let b = b as i32;
    let res: jint = a+b;
    env.call_method(callback, "factCallback", "(I)V", &[res.into()])
        .unwrap();
    res
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_player_thread_run<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    songs: jobjectArray,
    idx: jint
){

}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_setPlaylist<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    input: JObjectArray<'a>,
){
    // 将 Java String[] 转换为 Rust Vec<String>
    let input_vec: Vec<String> = (0..env.get_array_length(&input).unwrap())
        .map(|i| {
            let jstr: JString = env
                .get_object_array_element(&input, i)
                .expect("Failed to get array element")
                .into();
            env.get_string(&jstr)
                .expect("Failed to convert Java string")
                .into()
        })
        .collect();

    info!("Java_com_lee_MusicUtils_setPlaylist input_vec:{:?}",input_vec);
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_playlist(input_vec).expect("Failed to set playlist");
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_play<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    idx: jint
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.play(idx as usize).expect("Failed to play song");
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_pause<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.pause().expect("Failed to pause song");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_stop<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.stop().expect("Failed to stop song");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_nextSong<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.next_song().expect("Failed to play next song");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_previousSong<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.previous_song().expect("Failed to play previous song");
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_setPlayMode<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    id: jint
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_play_mode(PlayMode::id2mode(id)).expect("Failed to set play mode");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_setSpeed<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    speed: jfloat
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_speed(speed).expect("Failed to set speed");
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_setVolume<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    volume: jfloat
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_volume(volume).expect("Failed to set volume");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_getPos<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
)  {
    if let Ok(player) =  Player_instance.try_read(){
      //  player.get_pos().expect("Failed to get position")
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_getTotalLen<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
) -> jfloat {
    if let Ok(player) =  Player_instance.try_read(){
        player.get_total_len().expect("Failed to get total length").as_secs_f32()
    }else{
        0.0
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_getSongMetadata<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    file_path: JString<'a>,
) -> JString<'a> {
    let song_str: String = env.get_string(&file_path).unwrap().into();
    let metadata = utils::get_song_metadata(song_str.as_str()).expect("Failed to get song metadata");
    let output = env
    .new_string(metadata)
    .expect("Couldn't create java string!");
    output
}


#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_httpGet<'local>(
    mut env: JNIEnv<'local>,
    _class: JClass<'local>,
    url: JString<'local>,
) -> JString<'local> {
    let url_str: String = env.get_string(&url).unwrap().into();
    println!("rust url_str={:?}",url_str);
    let metadata = utils::http_get(url_str.as_str()).expect("Failed to get song metadata");
    let output = env
    .new_string(metadata)
    .expect("Couldn't create java string!");
    output
}




#[no_mangle]
pub extern "C" fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub extern "C" fn greet(name: *const std::os::raw::c_char) -> *const std::os::raw::c_char {
    let c_str = unsafe { std::ffi::CStr::from_ptr(name) };
    let name = c_str.to_str().unwrap();
    let greeting = format!("Hello, {} from Rust!", name);
    std::ffi::CString::new(greeting).unwrap().into_raw()
}

// 用于释放字符串内存
#[no_mangle]
pub extern "C" fn free_string(s: *mut std::os::raw::c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        std::ffi::CString::from_raw(s)
    };
}