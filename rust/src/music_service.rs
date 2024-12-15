use std::{
    collections::HashMap,
    io::{BufReader, Cursor},
    path::Path,
    sync::{Arc, Mutex, RwLock},
    thread,
    time::Duration,
};

use crate::{api::Result, frb_generated::StreamSink};
use lazy_static::lazy_static;
use rand::Rng;
use rodio::{Decoder, OutputStream, OutputStreamHandle, Sink, Source};
use serde::{Deserialize, Serialize};
use serde_json::Value;

lazy_static! {
    pub static ref Player_instance: Arc<Mutex<Player>> = Arc::new(Mutex::new(Player::new()));
}

#[derive(Debug, Clone)]
pub enum Mode {
    Ordering,
    Random,
    Single,
}

impl Mode {
    pub fn new(n: u8) -> Self {
        match n {
            0 => Mode::Ordering,
            1 => Mode::Random,
            2 => Mode::Single,
            _ => Mode::Ordering,
        }
    }
}

#[derive(Clone)]
pub struct Player {
    sink: Arc<Mutex<Sink>>,
    output_stream_handle: OutputStreamHandle,
    mode: Arc<RwLock<Mode>>,
    songs: Arc<RwLock<Vec<HashMap<String, String>>>>,
    idx: Arc<RwLock<i32>>,
    total_duration: Arc<RwLock<Duration>>,
}

impl Player {
    pub fn new() -> Self {
        let (_stream, output_stream_handle) = OutputStream::try_default().unwrap();
        let sink = Arc::new(Mutex::new(Sink::try_new(&output_stream_handle).unwrap()));
        let mode = Arc::new(RwLock::new(Mode::new(0)));
        let songs = Arc::new(RwLock::new(vec![]));
        let idx = Arc::new(RwLock::new(-1));
        let total_duration = Arc::new(RwLock::new(Duration::ZERO));
        Self {
            sink,
            output_stream_handle,
            mode,
            songs,
            idx,
            total_duration,
        }
    }

    pub fn add_src_play(&mut self, path: &str) -> Result<()> {
        if Self::url_start_http(path) {
            let _res = Self::play_online(&self, path).and_then(|x| {
                *self.total_duration.try_write().unwrap() = x.clone();
                Ok(Some(x))
            });
            return Ok(());
        }
        let file = std::fs::File::open(Path::new(path))?;
        let source = Decoder::new(BufReader::new(file))?;
        if let Some(total_time) = source.total_duration() {
            *self.total_duration.try_write().unwrap() = total_time;
        }
        let (_stream, output_stream) = OutputStream::try_default().unwrap();
        self.output_stream_handle = output_stream;
        *self.sink.lock().unwrap() = Sink::try_new(&self.output_stream_handle).unwrap();
        self.sink.lock().unwrap().append(source);
        self.sink.lock().unwrap().sleep_until_end();
        Ok(())
    }

    fn play_online(&self, url: &str) -> Result<Duration> {
        println!("play_online for url {}", url);
        let mut total_duration = Duration::ZERO;
        if let Ok(resp) = reqwest::blocking::get(url) {
            let cursor = Cursor::new(resp.bytes().unwrap());
            let url_source = Decoder::new(cursor).unwrap();
            total_duration = url_source.total_duration().unwrap_or(Duration::ZERO);
            self.sink.lock().unwrap().append(url_source);
        }
        Ok(total_duration)
    }

    fn url_start_http(path: &str) -> bool {
        path.starts_with("http")
    }

    pub fn add_songs(&self, mut song_v: Vec<HashMap<String, String>>) {
        let mut songs = self.songs.try_write().unwrap();
        songs.append(&mut song_v);
    }

    pub fn add_song(&self, song: HashMap<String, String>) {
        let mut songs = self.songs.try_write().unwrap();
        songs.push(song);
    }

    pub fn clean_songs(&self) {
        let mut songs = self.songs.try_write().unwrap();
        songs.clear();
    }

    pub fn play(&self) {
        self.sink.lock().unwrap().play();
    }

    pub fn seek(&self, secs: f32) {
        self.sink
            .lock()
            .unwrap()
            .try_seek(Duration::from_secs_f32(secs))
            .unwrap_or(());
    }

    pub fn pause(&self) {
        self.sink.lock().unwrap().pause();
    }

    pub fn is_play(&self) -> bool {
        self.sink.lock().unwrap().is_paused()
    }

    pub fn set_volum(&self, val: f32) {
        self.sink.lock().unwrap().set_volume(val);
    }

    pub fn set_speed(&self, val: f32) {
        self.sink.lock().unwrap().set_speed(val);
    }

    pub fn set_mode(&mut self, n: u8) {
        *self.mode.write().unwrap() = Mode::new(n)
    }

    pub fn stop(&self) {
        self.sink.lock().unwrap().stop();
    }

    pub fn get_pos(&self) -> Duration {
        self.sink.lock().unwrap().get_pos()
    }

    pub fn skip_one(&self) {
        self.sink.lock().unwrap().skip_one();
    }

    pub fn get_total_duration(&self) -> Duration {
        *self.total_duration.read().unwrap()
    }

    pub fn close(&self) {
        self.sink.try_lock().unwrap().clear();
    }

    pub fn run(
        &self,
        idx: Option<i32>,
        song_v: Vec<HashMap<String, String>>,
    ) {
        println!("player run begin");
        self.add_songs(song_v);
        let mut songs = self.songs.clone();
        if let Some(idx) = idx {
            *self.idx.write().unwrap() = idx;
        } else {
            *self.idx.write().unwrap() = 0;
        }
        let mut idx = self.idx.clone();
        let mut song_sink = self.sink.clone();
        let mode = self.mode.clone();
        let mut player = self.clone();
        println!("player _run idx:{}",idx.try_read().unwrap());
        loop {
            println!("player loop1 idx:{}",idx.try_read().unwrap());
            if song_sink.try_lock().unwrap().empty() {
                println!("song_sink3 empty:{}",idx.try_read().unwrap());
                match *mode.read().unwrap() {
                    Mode::Ordering => {
                        println!("song_sink3 Ordering empty:{}",idx.try_read().unwrap());
                        let id = idx.read().unwrap().clone();
                        if id < (songs.read().unwrap().len() as i32) - 1 {
                            *idx.write().unwrap() = id + 1;
                        } else {
                            *idx.write().unwrap() = 0;
                        }
                        println!("song_sink Ordering empty:{}",idx.try_read().unwrap());
                    }
                    Mode::Random => {
                        let len = songs.read().unwrap().len();
                        let mut rng = rand::thread_rng();
                        let n = rng.gen_range(0..len) as i32;
                        *idx.write().unwrap() = n;
                    }
                    Mode::Single => {}
                }
                println!("song_sink4 empty:{}",idx.try_read().unwrap());
                if let Some(song) = songs.read().unwrap().get(*idx.read().unwrap() as usize){
                    println!("song_sink4 empty idx:{}, song: {:#?}",idx.try_read().unwrap(),song);
                   let _ = player.add_src_play(song.get("url").unwrap().as_str()).unwrap();
                }
           
            }
            println!("player_thread_run idx:{}",idx.try_read().unwrap());
            thread::sleep(Duration::from_secs(1));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::Player;
    use super::Result;
    #[test]
    fn test1() -> Result<()> {
        let mut player = Player::new();
        player.add_src_play("src/music/夜的第七章.mp3")?;

        Ok(())
    }
}
