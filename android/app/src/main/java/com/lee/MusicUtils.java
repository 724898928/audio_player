package com.lee;

import android.util.Log;

import java.util.ArrayList;

public class MusicUtils {
    private final static String TAG = MusicUtils.class.getSimpleName();
    enum PlayMode {
        Normal,
        Loop,
        SingleLoop,
        Random,
    }
    // 声明native方法
//    protected static native void player_thread_run(ArrayList<String> songs, int idx);
//    protected static native void next_song();
//    protected static native void previous_song();
//    protected static native void set_playlist(ArrayList<String> songs);
//    protected static native void pause();
//    protected static native void stop();
//    protected static native void play(int idx);
//    protected static native void set_play_mode(PlayMode mode);
//    protected static native void seek(float tm);
//    protected static native void get_pos();
//    protected static native void set_speed(float v);
//    protected static native void set_volume(float v);
//    protected static native int get_total_len();
//    protected static native String get_song_metadata(String file_path);
//    protected static native String http_get(String url);
//    protected static native  void init_app();
    protected static native float add(int a, int b);

    static {
        Log.i(TAG, "System.loadLibrar: ");
        // System.loadLibrary("ssl");  // 加载.so文件
        // System.loadLibrary("crypto");  // 加载.so文件
        System.loadLibrary("rust_lib_audio_player");  // 加载.so文件
    }
}
