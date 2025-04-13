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
            Log.d("MainActivity", "Service 已绑定");
            MusicService.LocalBinder binder = (MusicService.LocalBinder) service;
            myService = binder.getService();
            isBound = true;
            Log.d("MainActivity", "Service 已绑定");

            // 绑定成功后调用 Service 方法
            myService.doTask("来自 Activity 的请求");
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
        Log.d(TAG,"onCreate");
        Intent intent = new Intent(this, MusicService.class);
        bindService(intent,connection, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        Log.d(TAG,"configureFlutterEngine");
        super.configureFlutterEngine(flutterEngine);
        eventPlugin = FlutterEventPlugin.registerWith(flutterEngine);
        methodPlugin = FlutterMethodPlugin.registerWith(flutterEngine);
        extracted();
    }

    private void extracted() {
        if (null != methodPlugin){
            handler = new Handler(Looper.myLooper()){
                @Override
                public void handleMessage(Message msg) {
                    //super.handleMessage(msg);
                    Api api = Api.getApi(msg.what);
                    Log.d(TAG,"handleMessage Api=" + api.toString());
                    methodPlugin.invokeMethod(api.name(),msg.obj);
//                    if (null != eventPlugin){
//                        eventPlugin.eventSink.success(msg.obj);
//                    }else {
//                        Log.d(TAG,"eventChannel == null");
//                    }

                }
            };
        }else {
            Log.d(TAG,"methodPlugin == null");
        }
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
}
