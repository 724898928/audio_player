use std::{ fs::File, io::BufReader, sync::{ mpsc, Arc, RwLock}, time::Duration};
use rust_lib_audio_player::{api::{Result},  music_service::{PlayMode, PlayerCommand,}};
use rodio::{Decoder, OutputStream, Sink};
use std::thread;

struct Player2 {
    is_playing: bool,
    command_sender: mpsc::Sender<PlayerCommand>,
    play_mode: PlayMode,
    playlist: Arc<RwLock<Vec<String>>>,
}

impl Player2 {
    pub fn new() -> Result<Self> {
        let (command_sender, command_receiver) = mpsc::channel();
        let playlist1: Arc<RwLock<Vec<String>>> = Arc::new(RwLock::new(vec![]));
        let playlist = playlist1.clone();
        thread::spawn(move || {
            let (_stream, handle) = OutputStream::try_default().unwrap();
            let mut sink = None::<Sink>;
            let mut current_track = 0;
            let mut play_mode = PlayMode::Normal;
            while let Ok(command) = command_receiver.recv() {
                println!("command :{:#?}, idx:{}",command,&current_track);
                match command {
                    PlayerCommand::Play => {
                       // playlist = vec![path];
                        current_track = 0;
                        Self::play_track(&handle, &mut sink, &*playlist.read().unwrap()[current_track]);
                    },
                    PlayerCommand::Pause => {
                        if let Some(s) = &sink {
                            s.pause();
                        }
                    },
                    PlayerCommand::Resume => {
                        if let Some(s) = &sink {
                            s.play();
                        }
                    },
                    PlayerCommand::Stop => {
                        if let Some(s) = &sink {
                            s.stop();
                        }
                        break;
                    },
                    PlayerCommand::SetPlayMode(mode) => {
                        play_mode = mode;
                    },
                    PlayerCommand::NextTrack => {
                        Self::next_track(&handle, &mut sink, &mut current_track, &playlist.read().unwrap(), &play_mode);
                    },
                    PlayerCommand::PreviousTrack => {
                        Self::previous_track(&handle, &mut sink, &mut current_track, &playlist.read().unwrap(), &play_mode);
                    },
                }

                if let Some(s) = &sink {
                    if s.empty() {
                        match play_mode {
                            PlayMode::Normal => {
                                if current_track < &playlist.read().unwrap().len() - 1 {
                                    current_track += 1;
                                    Self::play_track(&handle, &mut sink, &playlist.read().unwrap()[current_track]);
                                }
                            },
                            PlayMode::Loop => {
                                current_track = (current_track + 1) % &playlist.read().unwrap().len();
                                Self::play_track(&handle, &mut sink, &playlist.read().unwrap()[current_track]);
                            },
                            PlayMode::SingleLoop => {
                                Self::play_track(&handle, &mut sink, &playlist.read().unwrap()[current_track]);
                            },
                            PlayMode::Random => {
                                current_track = rand::random::<usize>() % &playlist.read().unwrap().len();
                                Self::play_track(&handle, &mut sink, &playlist.read().unwrap()[current_track]);
                            },
                        }
                    }
                }
            }
        });

        Ok(Player2 { 
            is_playing: false,
            command_sender,
            play_mode: PlayMode::Normal,
            playlist: playlist1,
        })
    }

    fn play_track(handle: &rodio::OutputStreamHandle, sink: &mut Option<Sink>, path: &str) {
        *sink = Some(Sink::try_new(handle).unwrap());
        if let Some(s) = sink {
            s.append(Self::get_source(path));
            s.play();
        }
    }
    
    fn get_source(path:&str) -> Decoder<BufReader<File>>{
        let file = std::fs::File::open(path)
        .unwrap();
        let source = Decoder::new(BufReader::new(file)).unwrap();
        source
    }
    fn next_track(handle: &rodio::OutputStreamHandle, sink: &mut Option<Sink>, current_track: &mut usize, playlist: &Vec<String>, play_mode: &PlayMode) {
        match play_mode {
            PlayMode::Normal | PlayMode::Loop => {
                *current_track = (*current_track + 1) % playlist.len();
            },
            PlayMode::SingleLoop => {},
            PlayMode::Random => {
                *current_track = rand::random::<usize>() % playlist.len();
            },
        }
        println!("next_track command :{:#?}, idx:{}, playlist:{:#?}",play_mode,&current_track,&playlist);
        Self::play_track(handle, sink, &playlist[*current_track]);
    }

    fn previous_track(handle: &rodio::OutputStreamHandle, sink: &mut Option<Sink>, current_track: &mut usize, playlist: &Vec<String>, play_mode: &PlayMode) {
        match play_mode {
            PlayMode::Normal | PlayMode::Loop => {
                *current_track = if *current_track == 0 { playlist.len() - 1 } else { *current_track - 1 };
            },
            PlayMode::SingleLoop => {},
            PlayMode::Random => {
                *current_track = rand::random::<usize>() % playlist.len();
            },
        }
        println!("previous_track command :{:#?}, idx:{}, playlist:{:#?}",play_mode, &current_track, &playlist);
        Self::play_track(handle, sink, &playlist[*current_track]);
    }

    pub fn play(&mut self) -> Result<()> {
        self.command_sender.send(PlayerCommand::Play)?;
        self.is_playing = true;
        Ok(())
    }

    pub fn set_playlist(&mut self, playlist: Vec<String>) {
        *self.playlist.try_write().unwrap() = playlist;
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

    pub fn is_playing(&self) -> bool {
        self.is_playing
    }
}

fn main() -> Result<()> {
    let mut player = Player2::new()?;

    // 设置播放列表
    player.set_playlist(vec![
        "D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3".to_string(),
        "D:\\flutter_pro\\audio_player\\rust\\src\\music\\118806715.mp3".to_string(),
        "D:\\flutter_pro\\audio_player\\rust\\src\\music\\614252728.mp3".to_string(),
    ]);

    // 开始播放
    player.play()?;

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


    // 设置播放列表
    // player.set_playlist(vec![
    //     "D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3".to_string(),
    //     "D:\\flutter_pro\\audio_player\\rust\\src\\music\\118806715.mp3".to_string(),
    //     "D:\\flutter_pro\\audio_player\\rust\\src\\music\\614252728.mp3".to_string(),
    // ]);