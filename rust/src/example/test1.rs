use rodio::{Decoder, OutputStream, Sink};
use std::{
    fs::File, io::BufReader, sync::mpsc::channel, thread, time::Duration
};

 fn get_source(path:&str) -> Decoder<BufReader<File>>{
    let file = std::fs::File::open(path)
    .unwrap();
    let source = Decoder::new(BufReader::new(file)).unwrap();
    source
}

fn main() {
    let (sender, rev) = channel::<u8>();
    // 创建一个播放线程
    thread::spawn(move || {
        let (_stream, handle) = OutputStream::try_default().unwrap();
            let sink = Sink::try_new(&handle).unwrap();
            while let Ok(a) = rev.recv() {
                if 1 == a {
                    println!("1");
                    sink.append(get_source("D:\\flutter_pro\\audio_player\\rust\\src\\music\\夜的第七章.mp3"));
                    sink.play();
                } else if 2 == a {
                    println!("2");
                    sink.clear();
                    sink.append(get_source("D:\\flutter_pro\\audio_player\\rust\\src\\music\\118806715.mp3"));
                    sink.play();
                }
            }
    });
    sender.send(1).unwrap();
    println!("音乐正在播放，您可以继续做其他事情!");
    thread::sleep(Duration::from_secs(10));
    sender.send(2).unwrap();
    thread::sleep(Duration::from_secs(10));
    println!("音乐正在播放，您可以继续做其他事情!");
}
