use std::collections::HashMap;

use audio_player::{api::{simple::player_thread_run, Result},frb_generated::StreamSink, music_service::{Player, Player_instance}};

fn main() -> Result<()> {
   // let mut plaryer = Player_instance.lock().unwrap();
   // plaryer.add_src_play("D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3")?;
    let mut songs = HashMap::new();
   songs.insert("url".to_string(), "D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3".to_string());
   player_thread_run(Some(0),vec![songs],None::<StreamSink<String>>);
    Ok(())
}
