package com.lee;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;

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

    public static native void nativeInit();
    public static native void pause();
    public static native void stop();
    public static native void setPlayMode(int modeId);
    public static native void seek(float tm);
    public static native void getPos();
    public static native void setSpeed(float v);
    public static native void setVolume(float v);
    public static native int getTotalLen();
    public static native int add(int a, int b, MusicUtils callback);
    public static native void setPlaylist(Object[] songs);
    public static native void play(int idx);

    public static native String httpGet(String url);
    public static native String hello(String name);
    public static native String getSongMetadata(String filePath);
    public static native void nextSong();
    public static native void previousSong();

    static {
        Log.i(TAG, "System.rust_lib_audio_player ");
        System.loadLibrary("rust_lib_audio_player");  // 加载.so文件
    }
    public void factCallback(int res) {
        System.out.println("factCallback: res = " + res);
    }
    public void httpGetCallback(String res) {
        System.out.println("factCallback: res = " + res);
    }
}
