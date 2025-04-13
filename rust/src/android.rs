use anyhow::Result;
use jni::{
    objects::{JClass, JObject, JString, JValue}, sys::jint, JNIEnv
};
use std::fmt::Display;
// #[no_mangle]
// pub extern "system" fn Java_com_lee_MusicUtils_player_thread_run(JNIEnv *, jclass, jobject, jint){
//
// }
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

