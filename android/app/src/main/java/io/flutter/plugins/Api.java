package io.flutter.plugins;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

public enum Api {
    UpdateDeviceStatus(0),
    RetrieveDeviceStatus(1),
    UpdateRecordStatus(2),
    RetrieveRecordStatus(3),
    DeleteDeviceStatus(4),
    DeleteDevice(5),
    RetrieveOnlineDevices(6),
    RetrieveAllDevices(7),
    RetrieveAllDevicesState(8),
    ReportGPSInfo(9),
    BatchReportGPSInfo(10),
    RetrievePeriodicGPSInfo(11),
    RetrieveLatestGPSInfo(12),
    ReportDeviceStatusAndGPSInfo(13),
    ReportDeviceStatusFrequency(14);
    int what;

    Api(int what) {
        this.what = what;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static Api getApi(int what) {
        for (Api api : Api.values()) {
           if (api.what == what){
               return api;
           }
        }
        return null;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static Api getApi(String name) {
        for (Api api : Api.values()) {
            if (api.name().equals(name)){
                return api;
            }
        }
        return null;
    }

    @NonNull
    @Override
    public String toString() {
        return "Api { name=" + this.name() + ", what= " + this.what + " }";
    }
}
