package com.lee;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class MusicService extends Service {
    static {
        System.loadLibrary("rust_lib_audio_player");  // 加载.so文件
    }
    // 声明native方法
   // public native int add(int a, int b);

    @Override
    public void onCreate() {
        super.onCreate();

    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}