package com.lee;

import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.media3.common.MediaItem;

import java.io.File;
import java.io.IOException;

public class MusicUtils {
    private final static String TAG = MusicUtils.class.getSimpleName();

//
//    static {
//        Log.i(TAG, "System.rust_lib_audio_player ");
//        System.loadLibrary("rust_lib_audio_player");  // 加载.so文件
//    }
//    public static native String  getSongMetadata(String filePath);

    @RequiresApi(api = Build.VERSION_CODES.GINGERBREAD_MR1)
    public static String getSongMetadata(String filePath) {
        Log.i(TAG, "getSongMetadata  filePath: "+filePath);
        MediaItem mediaItem = null;
        try {
             mediaItem = MediaItem.fromUri(filePath);
            if (null != mediaItem && null != mediaItem.mediaMetadata && null != mediaItem.mediaMetadata.title){
                Log.i(TAG, "getSongMetadata  mediaItem.mediaMetadata: "+mediaItem.mediaMetadata);
                String title = String.valueOf(mediaItem.mediaMetadata.title);
                String artist =  String.valueOf(mediaItem.mediaMetadata.artist);
                String album =  String.valueOf(mediaItem.mediaMetadata.albumArtist);
                String year =  String.valueOf(mediaItem.mediaMetadata.releaseYear);
                String track =  String.valueOf(mediaItem.mediaMetadata.trackNumber);
                String genre =   String.valueOf(mediaItem.mediaMetadata.genre);
                String res = String.format("{\"title\":\"%s\",\"artist\":\"%s\",\"album\":\"%s\",\"year\":\"%s\",\"track\":\"%s\",\"genre\":\"%s\"}",
                        title, artist, album, year, track, genre);
                Log.i(TAG, "getSongMetadata  res: "+res);
                return res;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        String[] filename = filePath.split("[\\/,.]");
        if (filename.length >=2){
            return "{\"title\":\"" + filename[filename.length -2]+"\"}";
        }
        return "";
    }

    @RequiresApi(api = Build.VERSION_CODES.GINGERBREAD_MR1)
    public static String extractMetadata(String filePath) {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            // 方式1：通过文件路径
            retriever.setDataSource(filePath);

            // 方式2：通过 Uri（适用于 ContentProvider）
            // retriever.setDataSource(context, Uri.parse("content://media/external/audio/media/123"));

            // 获取常见元数据
            String title = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE);
            String artist = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST);
            String year = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_YEAR);
            String album = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM);
            String track = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CD_TRACK_NUMBER);
            String duration = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            String genre = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_GENRE);

            // 获取专辑封面（返回 byte[]）
            byte[] albumArt = retriever.getEmbeddedPicture();

            Log.i("Metadata",
                    "Title: " + title + "\n" +
                            "Artist: " + artist + "\n" +
                            "Album: " + album + "\n" +
                            "Duration: " + duration + " ms");
            return String.format("{\"title\":\"%s\",\"artist\":\"%s\",\"album\":\"%s\",\"year\":\"%s\",\"track\":\"%s\",\"genre\":\"%s\"}",
                    title, artist, album, year, track, genre);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                retriever.release(); // 必须释放资源
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        String[] filename = filePath.split("[\\/,.]");
        if (filename.length >=2){
            return "{\"title\":\"" + filename[filename.length -2]+"\"}";
        }
        return "";
    }

}
