use std::{ fs::File, io::BufReader, sync::{ mpsc, Arc, RwLock}, time::Duration};
use rust_lib_audio_player::{api::Result, api::utils,  music_service::{PlayMode, Player, PlayerCommand}};
use rodio::{Decoder, OutputStream, Sink};
use std::thread;


fn main() -> Result<()> {

    let a =utils::get_song_metadata("A:\\Program Files\\Music\\孤勇者-陈奕迅.mp3");
    println!("song_metadata : {:?}",a);
    let mut player = Player::new()?;

    // 设置播放列表
    player.set_playlist(vec![
     //    "https://www.gequbao.com/music/6420".to_string(),
        "D:\\flutter_pro\\audio_player\\rust\\src\\music\\118806715.mp3".to_string(),
        "D:\\flutter_pro\\audio_player\\rust\\src\\music\\614252728.mp3".to_string(),
    ]);

    // 开始播放
    player.play(0)?;

    // 设置循环播放模式
    player.set_play_mode(PlayMode::Loop)?;

    // 播放5秒后切换到下一首
    thread::sleep(Duration::from_secs(5));
    player.next_song()?;
    
    // 再播放5秒后切换到上一首
    thread::sleep(Duration::from_secs(5));
    player.previous_song()?;

    // 设置随机播放模式
    player.set_play_mode(PlayMode::Random)?;

    // 再播放10秒后停止
    thread::sleep(Duration::from_secs(10));
    player.stop()?;

    Ok(())
}