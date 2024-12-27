use std::collections::HashMap;

#[tokio::main]
async fn main () -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://pd.musicapp.migu.cn/MIGUM2.0/v1.0/content/search_all.do?&ua=Android_migu&version=5.0.1&text=%E6%BC%A0%E6%B2%B3%E8%88%9E%E5%8E%85&pageNo=2&pageSize=10&searchSwitch={%22song%22:1,%22album%22:0,%22singer%22:0,%22tagSong%22:0,%22mvSong%22:0,%22songlist%22:0,%22bestShow%22:1}";
    let resp = reqwest::get(url)
        .await?
        .text()
        .await?;
    println!("{resp:#?}");

 Ok(())
}