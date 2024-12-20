use std::{collections::HashMap, thread, time::Duration as TDuration};


use chrono::Duration;

use crate::{frb_generated::StreamSink, music_service::{PlayMode, Player_instance}};

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn spawn_run(sink: StreamSink<String>){
    println!("spawn_run");
    thread::spawn(move||{
        println!("spawned thread print sleep begin");
        thread::sleep(TDuration::from_secs(20));
        for i in 0..5 {
            sink.add(format!("Message from rust thread:{}",i));
        }
        println!("spawned thread print sleep end");
    });
}

#[flutter_rust_bridge::frb(sync)]
pub fn player_thread_run(songs:Vec<String>,sink: StreamSink<String>){
    println!("player_thread_run begin");
    let mut plaryer = Player_instance.lock().unwrap();
    plaryer.set_playlist(songs);
    plaryer.get_pos(sink);
    plaryer.play();
    println!("player_thread_run end");

}
#[flutter_rust_bridge::frb(sync)]
pub fn next_song(_sink: StreamSink<String>){
   let mut player = Player_instance.lock().unwrap();
   player.next_song().expect("next_song failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn previous_song(_sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.previous_song().expect("previous_song failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_playlist(songs:Vec<String>,_sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.set_playlist(songs).expect("set_playlist failed!");
}
#[flutter_rust_bridge::frb(sync)]
pub fn pause(_sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.pause().expect("pause failed!");
}



#[flutter_rust_bridge::frb(sync)]
pub fn stop(_sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.stop().expect("stop failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn play(_sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.play().expect("play failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_play_mode(mode:PlayMode, _sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.set_play_mode(mode).expect("set_play_mode failed!");
}


#[flutter_rust_bridge::frb(sync)]
pub fn seek(tm:f64, _sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.seek(tm).expect("seek failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_pos(sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.get_pos(sink).expect("get_pos failed!");
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_speed(v:f32, _sink: StreamSink<String>){
    let mut player = Player_instance.lock().unwrap();
    player.set_speed(v).expect("seek failed!");
}


#[flutter_rust_bridge::frb(sync)]
pub fn get_total_len() -> Duration{
    let mut player = Player_instance.lock().unwrap();
    let t = player.get_total_len().expect("seek failed!");
    let ch_t = Duration::milliseconds(t.as_millis() as i64);
   // format!("{}:{}",ch_t.num_minutes(),ch_t.num_seconds())
   ch_t
}


#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
