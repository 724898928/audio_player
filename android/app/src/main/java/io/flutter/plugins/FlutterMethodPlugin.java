package io.flutter.plugins;

import android.util.Log;

import com.lee.MusicService;
import com.lee.MusicUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterMethodPlugin implements MethodChannel.MethodCallHandler, CallBack {

    private static final String TAG = FlutterMethodPlugin.class.getSimpleName();

    static String CALL_NATIVE_CHANNEL = "com.lee/call_native";

    private static MethodChannel methodChannel;

    private MusicService musicService;
    private FlutterMethodPlugin() {
    }

    public void setMusicService(MusicService musicService){
        this.musicService = musicService;
    }

    // 调用Flutter端方法, 无返回值
    public void invokeMethod(String method, Object o) {
        methodChannel.invokeMethod(method, o);
    }

    //android调用FLutter端方法, 有返回值
    public void invokeMethod(String method, Object o, MethodChannel.Result result) {
        methodChannel.invokeMethod(method, o, result);
    }


    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall call: " + call);
        Object res = null;
        String hello = MusicUtils.hello("lixin");
        Log.i(TAG, "来自rust : " + hello);
        Log.i(TAG, "configureFlutterEngine onMethodCall come from flutter reqPara: call.method: " + call.method + ", arguments : " + call.arguments);
        if (call.method.equals("Search")) {
            String a = null;
            try {
                List<Object> para = call.arguments();
                JSONObject reqPara = (JSONObject) JSONUtil.wrap(para.get(0));
                String url = reqPara.getString("url");
                Log.i(TAG, "configureFlutterEngine onMethodCall reqPara.getString url : " + url);
                a = MusicUtils.httpGet(url);
            } catch (JSONException e) {
               e.printStackTrace();
            }
            res = a;
        } else if (call.method.equals("SetPlayList")) {
            List<String> arguments =(List<String>) call.arguments;
            Log.i(TAG, "来自flutter songs : " +arguments);
            if (null != musicService){
                musicService.setPlaylist(arguments);
            }else {
                Log.e(TAG, "onMethodCall: musicService==null");
            }
           // res = "这个是来自native的问候! SetPlayList";
        } else if (call.method.equals("Play")) {
            List<Object> para = call.arguments();
            if (para.size() > 0){
                int idx = (int) para.get(0);
                if (null != musicService){
                    musicService.play(idx);
                }else {
                    Log.e(TAG, "onMethodCall: musicService==null");
                }
            //    res = "这个是来自native的问候!  play idx:" + idx;
            }else {
                Log.e(TAG, "idx == null");
            }

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
        Log.d(TAG, "callByAndroid obj" + obj.toString());
        //  this.invokeMethod("callByAndroid",obj);
    }
}
