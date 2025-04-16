package com.lee;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import java.util.ArrayList;
import java.util.Locale;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterCallbackInformation;
import android.os.IBinder;

public class MusicService extends Service {
    private final static String TAG = MusicService.class.getSimpleName();
    private FlutterEngine mEngine;

    private final IBinder binder = new LocalBinder();
    // Binder 子类，用于向 Activity 暴露 Service 实例
    public class LocalBinder extends Binder {
        MusicService getService() {
            return MusicService.this;
        }
    }
    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "MusicService onCreate ");
       // int s = MusicUtils.add(1,1,new MusicUtils());
       // Log.i(TAG, " MusicUtils s:"+s);
    }
    // 供 Activity 调用的方法
    public void doTask(String input) {
        Log.d(TAG, "执行任务: " + input);
    }
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);


        Log.d(TAG, "onStartCommand: ");
        if (null == mEngine){
            mEngine = new FlutterEngine(this);
            FlutterInjector.instance()
                    .flutterLoader()
                    .ensureInitializationComplete(this,null);
            long callbackHandle = intent.getLongExtra("handleId",-1);
            // 检索调用回调函数所需的实际回调信息
            FlutterCallbackInformation callbackInfo = FlutterCallbackInformation
                    .lookupCallbackInformation(callbackHandle);
            String dartBundlePath = FlutterInjector.instance()
                    .flutterLoader().findAppBundlePath();

            // 此处为兼容插件机制的v1版本,注册所有插件
            // 如果不这样做,其他插件在后台运行时将无法工作
//
//            mEngine.getDartExecutor().executeDartCallback(
//                    new DartExecutor.DartCallback(getAssets(),dartBundlePath,callbackInfo)
//            );

        }

        return START_STICKY;
    }
}