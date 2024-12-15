use std::{collections::HashMap, thread, time::Duration};

use serde_json::Value;

use crate::{frb_generated::StreamSink, music_service::{Player_instance}};

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(sync)]
pub fn spawn_run(sink: StreamSink<String>){
    println!("spawn_run");
    thread::spawn(move||{
        println!("spawned thread print sleep begin");
        thread::sleep(Duration::from_secs(20));
        for i in 0..5 {
            sink.add(format!("Message from rust thread:{}",i));
        }
        println!("spawned thread print sleep end");
    });
}

#[flutter_rust_bridge::frb(sync)]
pub fn player_thread_run(idx: Option<i32>, songs:Vec<HashMap<String,String>>, flu_sink: Option<StreamSink<String>>){
   let thread_1 = thread::spawn(move||{
        println!("player_thread_run begin");
        let plaryer = Player_instance.lock().unwrap();
        plaryer.run(idx, songs, flu_sink);
        println!("player_thread_run end");
    });
    thread_1.join().unwrap();
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
