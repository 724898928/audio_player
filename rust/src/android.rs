use anyhow::{Error, Result};
use jni::{
    objects::{JClass, JList, JObject, JObjectArray, JString, JValue},
    sys::{jfloat, jint, jobject}, JNIEnv
};
use symphonia::core::formats::util;
use std::fmt::Display;
use jni::sys::jstring;
use crate::{api::utils, android_service::Player_instance};

//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_next_song(JNIEnv *, jclass);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_previous_song(JNIEnv *, jclass);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_set_playlist(JNIEnv *, jclass, jobject);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_pause(JNIEnv *, jclass);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_stop<'e>(env: JNIEnv<'e>)->JObject<'e>{
//     env.new_object()
// }
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_play(JNIEnv *, jclass, jint);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_set_play_mode(JNIEnv *, jclass, jobject);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_seek(JNIEnv *, jclass, jfloat);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_get_pos(JNIEnv *, jclass);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_set_speed(JNIEnv *, jclass, jfloat);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_set_volume(JNIEnv *, jclass, jfloat);
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_get_total_len(JNIEnv *, jclass) -> jint;
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_get_song_metadata(JNIEnv *, jclass, jstring) -> jstring;
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_http_get(JNIEnv *, jclass, jstring) -> jstring;
//
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_init_app(JNIEnv *, jclass);

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
    songs: JObjectArray,
    idx: jint
){

}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_set_playlist<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    songs: JObjectArray<'a>,
    idx: jint
){
    if let Ok(mut player) =  Player_instance.try_write(){
           // 将 Java List<String> 转换为 Rust 的 Vec<String>
    let playlist: Vec<String> = 
        (0..env.get_array_length(&songs).unwrap())
            .map(|i| {
                let obj = env.get_object_array_element(&songs, i).unwrap();
                let song: String = env.get_string((&obj).into()).unwrap().into();
                song
            })
            .collect();
        player.set_playlist(playlist).expect("Failed to set playlist");
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
pub extern "system" fn Java_com_lee_MusicUtils_next_song<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.next_song().expect("Failed to play next song");
    }
}
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_previous_song<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.previous_song().expect("Failed to play previous song");
    }
}

// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_set_play_mode<'a>(
//     mut env: JNIEnv<'a>,
//     _class: JClass<'a>,
//     mode: JObject<'a>
// ){
//     if let Ok(mut player) =  Player_instance.try_write(){
//         player.set_play_mode(mode).expect("Failed to set play mode");
//     }
// }
#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_set_speed<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    speed: jfloat
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_speed(speed).expect("Failed to set speed");
    }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_set_volume<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    volume: jfloat
){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.set_volume(volume).expect("Failed to set volume");
    }
}
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_get_pos<'a>(
//     mut env: JNIEnv<'a>,
//     _class: JClass<'a>,
// ) -> jfloat {
//     if let Ok(player) =  Player_instance.try_read(){
//         player.get_pos().expect("Failed to get position")
//     }else{
//         0.0
//     }
// }

// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_get_total_len<'a>(
//     mut env: JNIEnv<'a>,
//     _class: JClass<'a>,
// ) -> jfloat {
//     if let Ok(player) =  Player_instance.try_read(){
//       //  player.get_total_len().expect("Failed to get total length")
//     }else{
//         0.0
//     }
// }

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_get_song_metadata<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    song: JString<'a>,
) -> JString<'a> {
    let song_str: String = env.get_string(&song).unwrap().into();
    let metadata = utils::get_song_metadata(song_str.as_str()).expect("Failed to get song metadata");
    let output = env
    .new_string(metadata)
    .expect("Couldn't create java string!");
output
}


// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_httpGet<'a>(
//     mut env: JNIEnv<'a>,
//     _class: JClass<'a>,
//     input: JString<'a>,
// ) -> JString<'a> {
//     let input: String = env
//         .get_string(&input)
//         .expect("Couldn't get java string!")
//         .into();
//     let output = env
//         .new_string(format!("Hello, {}!", input))
//         .expect("Couldn't create java string!");
//     output
// }
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
