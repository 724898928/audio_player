package com.lee;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterCallbackInformation;

public class MusicService extends Service {
    private final static String TAG = MusicService.class.getSimpleName();
    private FlutterEngine mEngine;

    static {
        System.loadLibrary("rust_lib_audio_player");  // 加载.so文件
       // System.loadLibrary("ssl");  // 加载.so文件
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

            mEngine.getDartExecutor().executeDartCallback(
                    new DartExecutor.DartCallback(getAssets(),dartBundlePath,callbackInfo)
            );

        }

        return START_STICKY;
    }
}