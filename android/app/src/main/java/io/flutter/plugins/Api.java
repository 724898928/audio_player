package io.flutter.plugins;

import android.os.Build;

public enum Api {
    Search(0);
    int what;

    Api(int what) {
        this.what = what;
    }

    public static Api getApi(int what) {
        for (Api api : Api.values()) {
           if (api.what == what){
               return api;
           }
        }
        return null;
    }

    public static Api getApi(String name) {
        for (Api api : Api.values()) {
            if (api.name().equals(name)){
                return api;
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return "Api { name=" + this.name() + ", what= " + this.what + " }";
    }
}
