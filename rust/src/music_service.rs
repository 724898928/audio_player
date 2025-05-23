use std::{
    fmt::Debug, io::{BufReader, Cursor}, sync::{mpsc, Arc, Mutex, RwLock}, thread, time::Duration as TDuration
};
#[cfg(not(target_os = "android"))]
use crate::{api::Result, frb_generated::StreamSink};

use lazy_static::lazy_static;
use rodio::{
    Decoder, OutputStream, Sink, Source,
};

lazy_static! {
    pub static ref Player_instance: Arc<RwLock<Player>> =
        Arc::new(RwLock::new(Player::new().unwrap()));
}

#[cfg(not(target_os = "android"))]
impl<T> Debug for StreamSink<T> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("StreamSink").field("base", &self).finish()
    }
}

#[derive(Debug, Clone)]
pub enum PlayerCommand {
    Play(usize),
    Pause,
    Resume,
    Stop,
    SetPlayMode(PlayMode),
    NextTrack,
    PreviousTrack,
    Seek(f64),
    Position,
    Speed(f32),
    Volume(f32),  //音量
}

#[derive(Debug, Clone, Copy)]
pub enum PlayMode {
    Normal,
    Loop,
    SingleLoop,
    Random,
}

impl PlayMode {
    fn get_id(&self) -> u8{
        match &self {
            PlayMode::Normal => 0,
            PlayMode::Loop => 1,
            PlayMode::SingleLoop => 2,
            PlayMode::Random => 3,
        }
    }

    fn values(&self) ->Vec<(u8, Self)>{
        vec![(0, PlayMode::Normal), (1, PlayMode::Loop), (2, PlayMode::SingleLoop), (3,PlayMode::Random)]
    }
}

#[derive(Clone)]
pub struct Player {
    is_playing: bool,
    command_sender: mpsc::Sender<PlayerCommand>,
    play_mode: PlayMode,
    playlist: Arc<RwLock<Vec<String>>>,
    flutter_sink: Arc<Mutex<Option<StreamSink<String>>>>,
    total_len: Arc<RwLock<TDuration>>,
}

impl Player {
    pub fn new() -> Result<Self> {
        let (command_sender, command_receiver) = mpsc::channel();
        let playlist1: Arc<RwLock<Vec<String>>> = Arc::new(RwLock::new(vec![]));
        let playlist = playlist1.clone();
        let flutter_sink = Arc::new(Mutex::new(None::<StreamSink<String>>));
        let flutter_sink2 = flutter_sink.clone();
        let total_len = Arc::new(RwLock::new(TDuration::ZERO));
        let total_duration = total_len.clone();
        thread::spawn(move || {
            let (_stream, handle) = OutputStream::try_default().unwrap();
            let mut sink = None::<Sink>;
            let mut current_track = 0;
            let mut play_mode = PlayMode::Loop;
            let mut play_speed: f32 = 1.0;
            let mut is_playing = false;
            // let mut total_duration = TDuration::ZERO;
            while let Ok(command) = command_receiver.recv() {
               // println!("command :{:#?}, idx:{}", command, &current_track);
                match command {
                    PlayerCommand::Play(i) => {
                        if playlist.read().unwrap().len() >0 {
                            current_track = i;
                          //  is_playing = true;
                            Self::play_track(
                                &handle,
                                &mut sink,
                                &*playlist.read().unwrap()[current_track],
                                &flutter_sink2,
                                &mut total_duration.write().unwrap(),
                                &play_speed,
                                &mut is_playing,
                            ); 
                        }
                    }
                
                    PlayerCommand::Pause => {
                        if let Some(s) = &sink {
                            is_playing = false;
                            s.pause();
                        }
                    }
                    PlayerCommand::Resume => {
                        if let Some(s) = &sink {
                            is_playing = true;
                            s.play();
                        }
                    }
                    PlayerCommand::Speed(v) => {
                        if let Some(s) = &sink {
                            play_speed = v;
                            s.set_speed(v);
                        }
                    }

                    PlayerCommand::Volume(v) => {
                        if let Some(s) = &sink {
                            s.set_volume(v);
                        }
                    }
                    PlayerCommand::Stop => {
                        if let Some(s) = &sink {
                            is_playing = false;
                            s.stop();
                        }
                        break;
                    }
                    PlayerCommand::SetPlayMode(mode) => {
                        play_mode = mode;
                    }
                    PlayerCommand::NextTrack => {
                        Self::next_track(
                            &handle,
                            &mut sink,
                            &mut current_track,
                            &playlist.read().unwrap(),
                            &play_mode,
                            &flutter_sink2,
                            &mut total_duration.write().unwrap(),
                            &play_speed,
                            &mut is_playing
                        );
                    }
                    PlayerCommand::PreviousTrack => {
                        Self::previous_track(
                            &handle,
                            &mut sink,
                            &mut current_track,
                            &playlist.read().unwrap(),
                            &play_mode,
                            &flutter_sink2,
                            &mut total_duration.write().unwrap(),
                            &play_speed,
                            &mut is_playing
                        );
                    }
                    PlayerCommand::Seek(t) => {
                        if let Some(s) = &mut sink {
                            s.try_seek(TDuration::from_secs_f64(t)).unwrap();
                        }
                    }
                    PlayerCommand::Position => {
                      //  print!("PlayerCommand::Position get_pos ");
                        if let Ok(mut guard) = flutter_sink2.try_lock() {
                            if let Some(f_s) = &mut *guard{
                                if let Some(s) = &mut sink {
                                    if let Ok(t_d) = total_duration.read() {
                                        let mut offset = s.get_pos().as_millis();
                                        // if offset.is_infinite() || offset.is_nan(){
                                        //     offset = 0.0_f64;
                                        // }
                                        f_s.add(format!(
                                            "{{\"pos\":{:?},\"len\":{:?}, \"playing\":{:?}, \"speed\":{:?}, \"mode\":{:?},\"idx\":{:?}}}",
                                            offset,
                                            &t_d.as_millis(),
                                            &is_playing,
                                            &play_speed,
                                            &play_mode.get_id(),
                                            &current_track
                                        ))
                                        .expect("Send flutter sink failed");
                                    }
                                }  
                            }
                        }
                    }
                }

                if let Some(s) = &sink {
                    if s.empty() {
                        match play_mode {
                            PlayMode::Normal => {
                                if current_track < &playlist.read().unwrap().len() - 1 {
                                    current_track += 1;
                                    Self::play_track(
                                        &handle,
                                        &mut sink,
                                        &playlist.read().unwrap()[current_track],
                                        &flutter_sink2,
                                        &mut total_duration.write().unwrap(),
                                        &play_speed,
                                        &mut is_playing
                                    );
                                }
                            }
                            PlayMode::Loop => {
                                current_track =
                                    (current_track + 1) % &playlist.read().unwrap().len();
                                Self::play_track(
                                    &handle,
                                    &mut sink,
                                    &playlist.read().unwrap()[current_track],
                                    &flutter_sink2,
                                    &mut total_duration.write().unwrap(),
                                    &play_speed,
                                    &mut is_playing
                                );
                            }
                            PlayMode::SingleLoop => {
                                Self::play_track(
                                    &handle,
                                    &mut sink,
                                    &playlist.read().unwrap()[current_track],
                                    &flutter_sink2,
                                    &mut total_duration.write().unwrap(),
                                    &play_speed,
                                    &mut is_playing
                                );
                            }
                            PlayMode::Random => {
                                current_track =
                                    rand::random::<usize>() % &playlist.read().unwrap().len();
                                Self::play_track(
                                    &handle,
                                    &mut sink,
                                    &playlist.read().unwrap()[current_track],
                                    &flutter_sink2,
                                    &mut total_duration.write().unwrap(),
                                    &play_speed,
                                    &mut is_playing
                                );
                            }
                        }
                    }
                }
            }
        });

        Ok(Player {
            is_playing: false,
            command_sender,
            play_mode: PlayMode::Normal,
            playlist: playlist1,
            flutter_sink,
            total_len,
        })
    }

    fn play_track(
        handle: &rodio::OutputStreamHandle,
        sink: &mut Option<Sink>,
        path: &str,
        _flu_sink: &Arc<Mutex<Option<StreamSink<String>>>>,
        total_duration: &mut TDuration,
        play_speed: &f32,
        is_playing: &mut bool
    ) {
        *sink = Some(Sink::try_new(handle).unwrap());
        if let Some(s) = sink {
            if Self::url_start_http(path) {
                Self::play_online(path, s, total_duration, is_playing);
            } else {
                if let Ok(file) = std::fs::File::open(path) {
                    if let Ok(source) = Decoder::new(BufReader::new(file)) {
                        *total_duration = source.total_duration().unwrap_or(TDuration::ZERO);
                        *is_playing = true;
                        s.append(source);
                    }
                }
            }
            println!("total_duration:{:?}", total_duration);
            s.set_speed(play_speed.to_owned());
            s.play();
        }
    }

    fn play_online<'a>(url: &str, sink: &mut Sink, total_duration: &mut TDuration, is_playing: &mut bool) {
       // println!("play_online for url {}", url);
        if let Ok(resp) = reqwest::blocking::get(url) {
            if let Ok(bytes) = resp.bytes() {
                let cursor = Cursor::new(bytes);
                if let Ok(url_source) = rodio::Decoder::new(cursor) {
                    *total_duration = url_source.total_duration().unwrap_or(TDuration::ZERO);
                    *is_playing = true;
                    sink.append(url_source);
                }
            }
        }
    }

    fn url_start_http(path: &str) -> bool {
        path.starts_with("http")
    }

    fn next_track(
        handle: &rodio::OutputStreamHandle,
        sink: &mut Option<Sink>,
        current_track: &mut usize,
        playlist: &Vec<String>,
        play_mode: &PlayMode,
        flu_sink: &Arc<Mutex<Option<StreamSink<String>>>>,
        total_duration: &mut TDuration,
        play_speed: &f32,
        is_playing: &mut bool,
    ) {
        match play_mode {
            PlayMode::Normal | PlayMode::Loop => {
                *current_track = (*current_track + 1) % playlist.len();
            }
            PlayMode::SingleLoop => {}
            PlayMode::Random => {
                *current_track = rand::random::<usize>() % playlist.len();
            }
        }
        // println!(
        //     "next_track command :{:#?}, idx:{}, playlist:{:#?}",
        //     play_mode, &current_track, &playlist
        // );
        Self::play_track(
            handle,
            sink,
            &playlist[*current_track],
            flu_sink,
            total_duration,
            play_speed,
            is_playing,
        );
    }

    fn previous_track(
        handle: &rodio::OutputStreamHandle,
        sink: &mut Option<Sink>,
        current_track: &mut usize,
        playlist: &Vec<String>,
        play_mode: &PlayMode,
        flu_sink: &Arc<Mutex<Option<StreamSink<String>>>>,
        total_duration: &mut TDuration,
        play_speed: &f32,
        is_playing: &mut bool
    ) {
        match play_mode {
            PlayMode::Normal | PlayMode::Loop => {
                *current_track = if *current_track == 0 {
                    playlist.len() - 1
                } else {
                    *current_track - 1
                };
            }
            PlayMode::SingleLoop => {}
            PlayMode::Random => {
                *current_track = rand::random::<usize>() % playlist.len();
            }
        }
        // println!(
        //     "previous_track command :{:#?}, idx:{}, playlist:{:#?}",
        //     play_mode, &current_track, &playlist
        // );
        Self::play_track(
            handle,
            sink,
            &playlist[*current_track],
            flu_sink,
            total_duration,
            play_speed,
            is_playing
        );
    }

    pub fn play(&mut self, i: usize) -> Result<()> {
        self.command_sender.send(PlayerCommand::Play(i))?;
        self.is_playing = true;
        Ok(())
    }

    pub fn del_song(&mut self, i: usize) -> Result<()>{
       let song = self.playlist.try_write().unwrap().remove(i);
        Ok(())
    }

    pub fn set_playlist(&mut self, playlist: Vec<String>) -> Result<()> {
        *self.playlist.try_write().unwrap() = playlist;
        Ok(())
    }  
     pub fn add_songs(&mut self, mut playlist: Vec<String>) -> Result<()> {
        self.playlist.try_write().unwrap().append(&mut playlist);
        Ok(())
    }

    pub fn pause(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::Pause)?;
        self.is_playing = false;
        Ok(())
    }

    pub fn resume(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::Resume)?;
        self.is_playing = true;
        Ok(())
    }

    pub fn stop(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::Stop)?;
        self.is_playing = false;
        Ok(())
    }

    pub fn set_play_mode(&mut self, mode: PlayMode) -> Result<()> {
        self.play_mode = mode.clone();
        self.command_sender.send(PlayerCommand::SetPlayMode(mode))?;
        Ok(())
    }

    pub fn next_song(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::NextTrack)?;
        Ok(())
    }

    pub fn previous_song(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::PreviousTrack)?;
        Ok(())
    }

    pub fn seek(&mut self, t: f64) -> Result<()> {
        self.command_sender.send(PlayerCommand::Seek(t))?;
        Ok(())
    }

    pub fn set_speed(&mut self, t: f32) -> Result<()> {
        self.command_sender.send(PlayerCommand::Speed(t))?;
        Ok(())
    }

    pub fn set_volume(&mut self, t: f32) -> Result<()> {
        self.command_sender.send(PlayerCommand::Volume(t))?;
        Ok(())
    }
    
    pub fn get_total_len(&mut self) -> Result<TDuration> {
        Ok(self.total_len.read().unwrap().clone())
    }

    pub fn get_pos(&mut self, sink: StreamSink<String>) -> Result<()> {
        self.flutter_sink.clear_poison();
        self.flutter_sink.try_lock().map(|mut x|{
            *x = Some(sink)
        });
        self.command_sender.send(PlayerCommand::Position)?;
        Ok(())
    }

    pub fn is_playing(&self) -> bool {
        self.is_playing
    }
}

#[cfg(test)]
mod tests {
    use std::thread;
    use std::time::Duration;

    use super::PlayMode;
    use super::Player;
    use super::Result;
    #[test]
    fn test1() -> Result<()> {
        let mut player = Player::new()?;
        player.set_playlist(vec![
            "D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3".to_string(),
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
}
