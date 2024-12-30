use std::{collections::HashMap, fmt::format};
//use ffmpeg_next as ffmpeg;
use crate::api::Result;
use id3::{Tag, TagLike};
use lazy_static::lazy_static;

lazy_static! {
    pub static ref MUSIC_EXTS: Vec<&'static str> = vec![".flac", ".mp3", ".wav", ".m4a", ".ogg"];
}

//pub fn get_song_metadata(file_path: &str) -> Result<String> {
    //     println!("get_song_metadata{:#?}", file_path);
    //     let mut res_map = HashMap::new();
    //    if let Ok(()) = ffmpeg::init(){
    //     match ffmpeg::format::input(file_path) {
    //         Ok(context) => {
    //            // let mut has_title = false;
    //             for (k,v) in context.metadata().iter() {
    //                 let k_lower = k.to_lowercase();
    //                 if v.starts_with("?"){
    //                     continue;
    //                 }
    //                 res_map.insert(k_lower, v.to_string());

    //             }
    //             res_map.insert("path".to_string(), file_path.to_string());
    //             res_map.insert("len".to_string(), (context.duration() as f64 / f64::from(ffmpeg::ffi::AV_TIME_BASE).round()).to_string());
    //             println!("read_from2: {:#?}", res_map);
    //             return Ok(serde_json::to_string(&res_map).unwrap());
    //         }
    //         Err(e) => {
    //             println!("Error reading metadata from file: {}", e);
    //         }
    //     }
    //    }
 //   Ok("".to_string())
//}

pub fn get_song_metadata(file_path: &str) -> Result<String>{
    // 读取 MP3 文件的 ID3 标签
    match Tag::read_from_path(file_path) {
        Ok(tag) => {
            // 获取文件中的元数据信息
            return Ok(format!(
                "{{
                \"title\": {:?},
                \"artist\": {:?},
                \"album\": {:?},
                \"year\":  {:?},
                \"track\": {:?},
                \"genre\": {:?},
                \"lyrics\": {:#?}
                 }}",
                tag.title().unwrap_or(""),
                tag.artist().unwrap_or(""),
                tag.album().unwrap_or(""),
                tag.year().unwrap_or(0),
                tag.track().unwrap_or(0),
                tag.genre().unwrap_or(""),
                tag.lyrics().collect::<Vec<&id3::frame::Lyrics>>()
            ));
            // Get frames before getting their content for more complex tags.
            // if let Some(artist) = tag.get("TPE1").and_then(|frame| frame.content().text()) {
            //     println!("artist: {}", artist);
            // }
        },
        Err(e) => {
            let title_1: Vec<&str>  = file_path.split(&['\\', '/', '.'][..]).collect();
            if title_1.len() >= 2 {
                return Ok(format!("{{\"title\":{:?}}}", title_1[title_1.len()-2]));
                
            }
            println!("Error reading ID3 tag: {}", e);
            return  Ok(format!("{{\"title\":\"\"}}"));
        }
    }
}

pub fn http_get(url: &str) -> Result<String> {
    let response = reqwest::blocking::get(url)?;
    Ok(response.text()?)
}