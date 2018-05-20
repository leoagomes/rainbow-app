import 'package:flutter/services.dart';

class ServiceHost {
  String name;
  String host;
  int port;

  ServiceHost(this.name, this.host, this.port);
}

class DeviceDiscoveryService {
  static const platform = const MethodChannel('xyz.leoag.colorz/discovery');

  bool running = false;

  Function onDeviceAddedCallback;
  Function onDeviceLostCallback;

  DeviceDiscoveryService(Function onDeviceAdded, Function onDeviceLost) {
    onDeviceAddedCallback = onDeviceAdded;
    onDeviceLostCallback = onDeviceLost;

    platform.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case "addHost":
          _addHost(call.arguments);
          break;
        case "removeHost":
          _removeHost(call.arguments as String);
          break;
      }
    });
  }

  void _addHost(Map hostData) {
    var device = new ServiceHost(hostData['name'], hostData['address'],
        int.parse(hostData['port']));
    Function.apply(onDeviceAddedCallback, [device]);
  }

  void _removeHost(String name) {
    Function.apply(onDeviceLostCallback, [name]);
  }

  void startListening() {
    platform.invokeMethod("startListening").then((_) {
      running = true;
    });
  }

  void stopListening() {
    platform.invokeMethod("stopListening").then((_) {
      running = false;
    });
  }
}