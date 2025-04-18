use anyhow::{Error, Result};
use jni::{objects::{JClass, JList, JObject, JObjectArray, JString, JValue}, sys::{jfloat, jint, jobject, jobjectArray, jvalue}, JNIEnv, JavaVM};
use std::fmt::Display;
use std::thread;
use std::time::Duration;
use crate::{android_service::{PlayMode, Player_instance}, api::utils};
use log::{Level, LevelFilter};
use android_logger::{Config,FilterBuilder};
use once_cell::sync::OnceCell;
pub static GLOBAL_JVM: OnceCell<JavaVM> = OnceCell::new();

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
pub extern "system" fn Java_com_lee_MusicUtils_nativeInit<'a>(
   mut env: JNIEnv<'a>,
    _class: jni::objects::JClass,
) {
    // 将传入的 JavaVM 指针转换为 Rust 对象并缓存起来
    let java_vm = env.get_java_vm().unwrap();
    GLOBAL_JVM.set(java_vm).expect("Failed to set GLOBAL_JVM");
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
    //将 Java String[] 转换为 Rust Vec<String>
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
      // 获取 JavaVM 的引用，后续用来在线程中附加当前线程
     if let Ok(mut player) =  Player_instance.try_write(){
        // player.set_playlist(input_vec).expect("Failed to set playlist");
     }
}

#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_play<'a>(
    mut env: JNIEnv<'a>,
    _class: JClass<'a>,
    idx: jint
){
    if let Ok(mut player) =  Player_instance.try_write(){
     //   player.play(idx as usize).expect("Failed to play song");
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



#[no_mangle]
pub extern "system" fn Java_com_lee_MusicUtils_createRustThread(
    env: JNIEnv,
    _class: JClass,
) {
    // 获取 JavaVM 的引用，后续用来在线程中附加当前线程
    let java_vm = env.get_java_vm().unwrap();

    // 在新线程中执行任务
    thread::spawn(move || {
        // 在新线程中附加当前线程到 JVM 以获得 JNIEnv
        let env = java_vm.attach_current_thread().unwrap();

        // 示例任务：打印信息并休眠一段时间
        println!("Rust 线程已启动，在新线程中附加了 JNI 环境！");
        info!("Rust 线程已启动，在新线程中附加了 JNI 环境！");
        // 如果需要回调 Java 方法，则可通过 env 调用相应方法

        // 模拟一段耗时任务
        thread::sleep(Duration::from_secs(3));

        // 示例：在线程中调用一个 Java 方法（如更新 UI 或通知）
        // 这里仅做示例，如果需要调用 Java 方法，需要先查找到目标类和方法签名
        // 例如：
        // let class = env.find_class("com/example/myapp/SomeJavaClass").unwrap();
        // let method_id = env.get_static_method_id(class, "onRustTaskFinished", "()V").unwrap();
        // env.call_static_method(class, method_id, jni::signature::ReturnType::Void, &[]).unwrap();

        println!("Rust 线程任务结束！");
        info!("Rust 线程任务结束！");
    });
}