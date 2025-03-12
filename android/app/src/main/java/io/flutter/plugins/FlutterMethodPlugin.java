package io.flutter.plugins;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import org.json.JSONObject;

import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.JSONUtil;
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

    // 调用FLutter端方法, 有返回值
    public void invokeMethod(String method, Object o, MethodChannel.Result result){
        methodChannel.invokeMethod(method,o,result);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        List<Object> para = call.arguments();
        String serverUrl = (String) para.get(0);
        JSONObject reqPara = (JSONObject) JSONUtil.wrap(para.get(1));
        Object res = null;
        Log.i("configureFlutterEngine onMethodCall come from flutter reqPara:", "serverUrl : " + serverUrl + " reqPara: " + reqPara.toString());
         if (call.method.equals("call_native")) {
             result.success("这个是来自native的问候!");
         } else if (call.method.equals("get_device_state")) {
            res = "这个是来自native get_device_state的问候! res: ";
         } else if (call.method.equals("get_gps_info")) {
             res = "这个是来自native get_gps_info的问候!2303B400002 res: ";
         }
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
