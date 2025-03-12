package com.lee;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
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
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG,"onCreate");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        Log.d(TAG,"configureFlutterEngine");
        super.configureFlutterEngine(flutterEngine);
        eventPlugin = FlutterEventPlugin.registerWith(flutterEngine);
        methodPlugin = FlutterMethodPlugin.registerWith(flutterEngine);
        extracted();
    }

    private void extracted() {
        if (null != methodPlugin){
            handler = new Handler(Looper.myLooper()){
                @RequiresApi(api = Build.VERSION_CODES.N)
                @Override
                public void handleMessage(@NonNull Message msg) {
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
