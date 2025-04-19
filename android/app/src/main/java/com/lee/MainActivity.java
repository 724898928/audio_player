package com.lee;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.Api;
import io.flutter.plugins.FlutterEventPlugin;
import io.flutter.plugins.FlutterMethodPlugin;

public class MainActivity extends FlutterActivity{
    private final static String TAG = MainActivity.class.getSimpleName();
    private Handler handler;
    private MusicService myService;

    private boolean isBound = false;
    private FlutterEventPlugin eventPlugin;
    private FlutterMethodPlugin methodPlugin;

    // 定义 ServiceConnection
    private ServiceConnection connection = new ServiceConnection(){
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.d(TAG, "MainActivity onServiceConnected Service 已绑定");
            myService = ((MusicService.LocalBinder) service).getService();
            isBound = true;
            // 绑定成功后调用 Service 方法
           // myService.doTask("来自 Activity 的请求");
            if (null != methodPlugin){
                methodPlugin.setMusicService(myService);
            }else{
                Log.e(TAG, "onCreate: methodPlugin==null");
            }
            if (null != eventPlugin){
                eventPlugin.setMusicService(myService);
            }else{
                Log.e(TAG, "onCreate: eventPlugin==null");
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            isBound = false;
            Log.d("MainActivity", "Service 解绑");
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG,"MainActivity onCreate");
        Intent intent = new Intent(this, MusicService.class);
        bindService(intent,connection, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        Log.d(TAG,"MainActivity configureFlutterEngine");
        super.configureFlutterEngine(flutterEngine);
        methodPlugin = FlutterMethodPlugin.registerWith(flutterEngine);
        eventPlugin = FlutterEventPlugin.registerWith(flutterEngine);
       // extracted();
    }

    private void extracted() {
        handler = new Handler(Looper.myLooper()){
            @Override
            public void handleMessage(Message msg) {
                //super.handleMessage(msg);
                Api api = Api.getApi(msg.what);
                Log.d(TAG,"handleMessage Api=" + api.toString());
                if (null != methodPlugin){
                    methodPlugin.invokeMethod(api.name(),msg.obj);
                    if (null != eventPlugin){
                        eventPlugin.eventSink.success(msg.obj);
                    }else {
                        Log.d(TAG,"eventChannel == null");
                    }
                }else {
                    Log.d(TAG,"methodPlugin == null");
                }
                if (null != myService){

                }
            }
        };

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 解绑 service
        if(isBound){
            unbindService(connection);
            isBound = false;
        }
    }

    // UI 按钮点击示例
    public void onPlayClicked(int index) {
        if (isBound) {
       //     myService.player.play(index);
        }
    }

    public void onPauseClicked() {
        if (isBound) {
     //       myService.player.pause();
        }
    }
}
