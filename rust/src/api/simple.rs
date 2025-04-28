use std::{thread, time::Duration as TDuration};


use chrono::Duration;

use crate::{frb_generated::StreamSink, music_service::{PlayMode, Player_instance}};

#[flutter_rust_bridge::frb(sync)]
pub fn player_thread_run(songs:Vec<String>, idx: usize, sink: StreamSink<String>){
  //  println!("player_thread_run begin");
   if let Ok(mut player) = Player_instance.try_write(){
       player.set_playlist(songs);
       player.get_pos(sink);
       player.play(idx);
   }
  //  println!("player_thread_run end");

}
#[flutter_rust_bridge::frb(sync)]
pub fn next_song(_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
        player.next_song().expect("next_song failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn previous_song(_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.previous_song().expect("previous_song failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_playlist(songs:Vec<String>,_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.set_playlist(songs).expect("set_playlist failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn add_songs(songs:Vec<String>,_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.add_songs(songs).expect("add_songs failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn pause(_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.pause().expect("pause failed!");
    }
}



#[flutter_rust_bridge::frb(sync)]
pub fn stop(_sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.stop().expect("stop failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn play(idx: usize, _sink: StreamSink<String>){
    if let Ok(mut player) =  Player_instance.try_write(){
    player.play(idx).expect("play failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_play_mode(mode:PlayMode, _sink: StreamSink<String>){
    if let Ok(mut player) = Player_instance.try_write(){
    player.set_play_mode(mode).expect("set_play_mode failed!");
    }
}


#[flutter_rust_bridge::frb(sync)]
pub fn seek(tm:f64, _sink: StreamSink<String>){
    if let Ok(mut player) = Player_instance.try_write(){
    player.seek(tm).expect("seek failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_pos(sink: StreamSink<String>){
   // print!("flutter_rust_bridge get_pos ");
   if let Ok(mut player) = Player_instance.try_write(){
    player.get_pos(sink).expect("get_pos failed!");
   }
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_speed(v:f32, _sink: StreamSink<String>){
    if let Ok(mut player) = Player_instance.try_write(){
    player.set_speed(v).expect("seek failed!");
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn set_volume(v:f32, _sink: StreamSink<String>){
    if let Ok(mut player) = Player_instance.try_write(){
    player.set_volume(v).expect("set_volume failed!")
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_total_len() -> Duration{
    if let Ok(mut player) = Player_instance.try_write(){
        let t = player.get_total_len().expect("seek failed!");
        let ch_t = Duration::milliseconds(t.as_millis() as i64);
       // format!("{}:{}",ch_t.num_minutes(),ch_t.num_seconds())
       ch_t
    }
    else{
        Duration::zero()
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_song_metadata(file_path: String) -> String{
    crate::api::utils::get_song_metadata(&file_path).expect("get_song_metadata failed!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn http_get(url: String) -> String{
    crate::api::utils::http_get(&url).expect("get_song_metadata2 failed!")
}


#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

