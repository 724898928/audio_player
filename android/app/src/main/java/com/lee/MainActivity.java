package com.lee;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
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

    private FlutterEventPlugin eventPlugin;
    private FlutterMethodPlugin methodPlugin;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG,"onCreate");
        Intent intent = new Intent(this, MusicService.class);
        startService(intent);
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
}
