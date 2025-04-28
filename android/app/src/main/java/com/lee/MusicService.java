package com.lee;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;

public class MusicService extends Service {
    private final static String TAG = MusicService.class.getSimpleName();
    private FlutterEngine mEngine;

    private AudioPlayer player;
    private final IBinder binder = new LocalBinder();


    // Binder 子类，用于向 Activity 暴露 Service 实例

    public class LocalBinder extends Binder {
        public MusicService getService() {
            return MusicService.this;
        }
    }


    @Override
    public void onCreate() {
        super.onCreate();
        player = new AudioPlayer(this);
        Log.d(TAG, "MusicService onCreate ");
    }
    // 暴露给客户端的控制方法
    public void setPlaylist(ArrayList<String> list) {
        player.setPlaylist(list);
    }
    public void addSongs(ArrayList<String> list) {
        player.addSongs(list);
    }

    public void clearPlaylist() {
        player.clearPlaylist();
    }
    public void play(int idx) {
        player.play(idx);
    }
    public void pause() {
        player.pause();
    }
    public void resume() {
        player.resume();
    }
    public void next() {
        player.next();
    }
    public void previous() {
        player.previous();
    }
    public void setMode(int mode) {
        player.setPlayMode(PlayMode.fromId(mode));
    }
    public void seek(long pos) {
        player.seek(pos);
    }
    public void stop() {
        player.stop();
    }
    public void setSpeed(float speed) {
        player.setSpeed(speed);
    }
    public void setVolume(float speed) {
        player.setVolume(speed);
    }
    public boolean isPlaying() {
        return player.isPlaying();
    }
    // 供 Activity 调用的方法

    public String getCurrentInfo(){
        return player.getCurrentInfo();
    }
    public long totalLen() {
        return player.totalLen();
    }
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        Log.d(TAG, "onStartCommand: ");
//        if (null == mEngine){
//            mEngine = new FlutterEngine(this);
//            FlutterInjector.instance()
//                    .flutterLoader()
//                    .ensureInitializationComplete(this,null);
//            long callbackHandle = intent.getLongExtra("handleId",-1);
//            // 检索调用回调函数所需的实际回调信息
//            FlutterCallbackInformation callbackInfo = FlutterCallbackInformation
//                    .lookupCallbackInformation(callbackHandle);
//            String dartBundlePath = FlutterInjector.instance()
//                    .flutterLoader().findAppBundlePath();

            // 此处为兼容插件机制的v1版本,注册所有插件
            // 如果不这样做,其他插件在后台运行时将无法工作
//
//            mEngine.getDartExecutor().executeDartCallback(
//                    new DartExecutor.DartCallback(getAssets(),dartBundlePath,callbackInfo)
//            );
   //     }

        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "MusicService onDestroy: ");
        player.releasePlayer();
        super.onDestroy();
    }
}