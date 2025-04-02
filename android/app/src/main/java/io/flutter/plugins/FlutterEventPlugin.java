package io.flutter.plugins;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class FlutterEventPlugin implements EventChannel.StreamHandler{
    private static String CALL_FLUTTER_CHANNEL = "com.lee/call_flutter";
    public EventChannel.EventSink eventSink;
    public static FlutterEventPlugin registerWith(FlutterEngine flutterEngine) {
        EventChannel eventChannel = new EventChannel(flutterEngine.getDartExecutor(), CALL_FLUTTER_CHANNEL);
        FlutterEventPlugin myFlutterEventPlugin = new FlutterEventPlugin();
        eventChannel.setStreamHandler(myFlutterEventPlugin);
        return myFlutterEventPlugin;
    }


    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = events;
        this.eventSink.success("Event ");
//        for (int i = 0; i < 100; i++) {
//            this.eventSink.success("Event "+i);
//            try {
//                Thread.sleep(1000);
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }
//        }
    }

    @Override
    public void onCancel(Object arguments) {

    }
}
