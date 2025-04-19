package com.lee;

import android.media.MediaMetadataRetriever;

import java.io.File;

public class MusicUtils {
    private final static String TAG = MusicUtils.class.getSimpleName();
    public static String getSongMetadata(String filePath) throws Exception {
        MediaMetadataRetriever mmr = null;
        try {
            mmr = new MediaMetadataRetriever();
            File file = new File(filePath);
            if (!file.exists()) {
                return "{\"title\":\"\"}";
            }

            mmr.setDataSource(filePath);

            String title = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE));
            String artist = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST));
            String album = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM));
            String year = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_YEAR));
            String track = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_CD_TRACK_NUMBER));
            String genre = getSafeString(mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_GENRE));

            return String.format("{\"title\":\"%s\",\"artist\":\"%s\",\"album\":\"%s\",\"year\":\"%s\",\"track\":\"%s\",\"genre\":\"%s\"}",
                    title, artist, album, year, track, genre);

        } finally {
            if (null != mmr){
                mmr.release();
            }
        }
    }

    private static String getSafeString(String value) {
        return value != null ? value : "";
    }
}
