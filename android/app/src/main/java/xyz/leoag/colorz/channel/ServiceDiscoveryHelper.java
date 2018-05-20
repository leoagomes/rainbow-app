package xyz.leoag.colorz.channel;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.net.nsd.NsdManager;
import android.net.nsd.NsdServiceInfo;
import android.os.Build;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServiceDiscoveryHelper {
    private static String TAG = "ServiceDiscoveryHelper";
    private static String CHANNEL = "xyz.leoag.colorz/discovery";

    String serviceType = "_colorz._tcp";

    MethodChannel methodChannel;

    Context context;
    NsdManager nsdManager;
    NsdManager.ResolveListener resolveListener;
    NsdManager.DiscoveryListener discoveryListener;

    public ServiceDiscoveryHelper(Context context) {
        this.context = context;

        nsdManager = (NsdManager)context.getSystemService(Context.NSD_SERVICE);
        initDiscoveryListener();
        initResolverListener();
    }

    @SuppressLint("NewApi")
    private void initResolverListener() {
        resolveListener = new NsdManager.ResolveListener() {
            @Override
            public void onResolveFailed(NsdServiceInfo serviceInfo, int errorCode) {
                Log.d(TAG, "Failed to resolve service: " + serviceInfo.toString());
            }

            @Override
            public void onServiceResolved(NsdServiceInfo serviceInfo) {
                Log.d(TAG, "Service Resolved!");

                HashMap<String, String> map = new HashMap<>();
                map.put("name", serviceInfo.getServiceName());
                map.put("address", serviceInfo.getHost().getHostAddress());
                map.put("port", String.valueOf(serviceInfo.getPort()));

                Log.d(TAG, map.toString());

                methodChannel.invokeMethod("addHost", map);
            }
        };
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    private void initDiscoveryListener() {
        discoveryListener = new NsdManager.DiscoveryListener() {
            @Override
            public void onStartDiscoveryFailed(String serviceType, int errorCode) {
                nsdManager.stopServiceDiscovery(this);
                Log.d(TAG, "Start discovery failed. Error: " + errorCode);
            }

            @Override
            public void onStopDiscoveryFailed(String serviceType, int errorCode) {
                nsdManager.stopServiceDiscovery(this);
                Log.d(TAG, "Stop discovery failed. Error: " + errorCode);
            }

            @Override
            public void onDiscoveryStarted(String serviceType) {
                Log.i(TAG, "Discovery Started. Expected service type: " + serviceType);
            }

            @Override
            public void onDiscoveryStopped(String serviceType) {
                Log.i(TAG, "Discovery Stopped.");
            }

            @Override
            public void onServiceFound(NsdServiceInfo serviceInfo) {
                Log.d(TAG, "Service found! " + serviceInfo.toString());
                nsdManager.resolveService(serviceInfo, resolveListener);
            }

            @Override
            public void onServiceLost(NsdServiceInfo serviceInfo) {
                Log.d(TAG, "Service lost! " + serviceInfo.toString());
                methodChannel.invokeMethod("removeHost", serviceInfo.getServiceName());
            }
        };
    }

    public void initMethodChannel(FlutterView view) {
        methodChannel = new MethodChannel(view, CHANNEL);
        methodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        switch (methodCall.method) {
                            case "startListening":
                                startListening();
                                result.success(null);
                                break;
                            case "stopListening":
                                stopListening();
                                result.success(null);
                                break;
                            default:
                                Log.e(TAG, "Unknown method call " + methodCall.method);
                                break;
                        }
                    }
                }
        );
    }

    @SuppressLint("NewApi")
    public void startListening() {
        nsdManager.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, discoveryListener);
    }

    @SuppressLint("NewApi")
    public void stopListening() {
        nsdManager.stopServiceDiscovery(discoveryListener);
    }
}
