package io.flutter.plugins;

import android.util.Log;

import com.lee.MusicUtils;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterMethodPlugin implements MethodChannel.MethodCallHandler, CallBack {

    private static final String TAG = FlutterMethodPlugin.class.getSimpleName();

    static String CALL_NATIVE_CHANNEL = "com.lee/call_native";

    private static MethodChannel methodChannel;

    private FlutterMethodPlugin() {
    }

    // 调用Flutter端方法, 无返回值
    public void invokeMethod(String method, Object o){
        methodChannel.invokeMethod(method,o);
    }

    //android调用FLutter端方法, 有返回值
    public void invokeMethod(String method, Object o, MethodChannel.Result result){
        methodChannel.invokeMethod(method,o,result);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall call: "+call);
        Object res = null;
        Log.i(TAG,"configureFlutterEngine onMethodCall come from flutter reqPara: call.method: "+call.method+", arguments : "+call.arguments);
         if (call.method.equals("Search")) {
           int a = MusicUtils.add(1,1, new MusicUtils());
             res = "这个是来自native的问候! a="+a;
         } else if (call.method.equals("get_device_state")) {
            res = "这个是来自native get_device_state的问候! res: ";
         } else if (call.method.equals("get_gps_info")) {
             res = "这个是来自native get_gps_info的问候!2303B400002 res: ";
         }
        result.success(res);
    }

    public static FlutterMethodPlugin registerWith(FlutterEngine flutterEngine) {
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CALL_NATIVE_CHANNEL);
        FlutterMethodPlugin myFlutterPlugin = new FlutterMethodPlugin();
        methodChannel.setMethodCallHandler(myFlutterPlugin);
        return myFlutterPlugin;
    }

    @Override
    public void call(Object obj) {
        Log.d(TAG, "callByAndroid obj"+obj.toString());
      //  this.invokeMethod("callByAndroid",obj);
    }
}
