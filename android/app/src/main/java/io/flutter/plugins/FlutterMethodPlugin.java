package io.flutter.plugins;

import android.util.Log;

import com.lee.MusicService;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlutterMethodPlugin implements MethodChannel.MethodCallHandler, CallBack {

    private static final String TAG = FlutterMethodPlugin.class.getSimpleName();

    static String CALL_NATIVE_CHANNEL = "com.lee/call_native";

    private static MethodChannel methodChannel;

    private MusicService musicService;

    private FlutterMethodPlugin() {
    }

    public void setMusicService(MusicService musicService) {
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
        Log.i(TAG, "configureFlutterEngine onMethodCall come from flutter reqPara: call.method: " + call.method + ", arguments : " + call.arguments);
        if (null != musicService) {
            if (call.method.equals("SetPlayList")) {
                List<String> arguments = (List<String>) call.arguments;
                Log.i(TAG, "来自flutter songs : " + arguments);
                if (null != musicService) {
                    musicService.setPlaylist(arguments);
                } else {
                    Log.e(TAG, "onMethodCall: musicService==null");
                }
                // res = "这个是来自native的问候! SetPlayList";
            } else if (call.method.equals("Play")) {
                List<Object> para = call.arguments();
                if (para.size() > 0) {
                    int idx = (int) para.get(0);
                    if (null != musicService) {
                        musicService.play(idx);
                    } else {
                        Log.e(TAG, "onMethodCall: musicService==null");
                    }
                    //    res = "这个是来自native的问候!  play idx:" + idx;
                } else {
                    Log.e(TAG, "idx == null");
                }

            } else if (call.method.equals("GetCurrentInfo")) {
                res = musicService.getCurrentInfo();
            } else if (call.method.equals("Next")) {
                musicService.next();
            } else if (call.method.equals("Previous")) {
                musicService.previous();
            } else if (call.method.equals("Pause")) {
                musicService.pause();
            } else if (call.method.equals("Stop")) {
                musicService.stop();
            } else if (call.method.equals("PlayMode")) {
                List<Object> para = call.arguments();
                if (para.size() > 0) {
                    int idx = (int) para.get(0);
                    musicService.setMode(idx);
                } else {
                    Log.e(TAG, "PlayMode == null");
                }
            }else if (call.method.equals("Seek")) {
                List<Object> para = call.arguments();
                if (para.size() > 0) {
                    long pross = (long) para.get(0);
                    musicService.seek(pross);
                } else {
                    Log.e(TAG, "Seek == null");
                }
            }else if (call.method.equals("Speed")) {
                List<Object> para = call.arguments();
                if (para.size() > 0) {
                    long pross = (long) para.get(0);
                    musicService.setSpeed(pross);
                } else {
                    Log.e(TAG, "Speed == null");
                }
            }else if (call.method.equals("Volume")) {
                List<Object> para = call.arguments();
                if (para.size() > 0) {
                    float pross = (float) para.get(0);
                    musicService.setVolume(pross);
                } else {
                    Log.e(TAG, "Volume == null");
                }
            }else if (call.method.equals("TotalLen")) {
                res = musicService.totalLen();
            }
        } else {
            Log.e(TAG, "onMethodCall: musicService==null");
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
