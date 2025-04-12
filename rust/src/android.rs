use jni::JNIEnv;
use jni::objects::JObject;
use jni::sys::{jint, jstring, jobject, jfloat, jclass};

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
pub extern "system" fn Java_com_lee_MusicUtils_add(a: jint, b: jint) -> jint {
    a + b
}
