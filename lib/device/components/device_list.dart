import '../pages/device_info.dart';
import '../shared/dtos.dart';
import '../shared/device_discovery_service.dart';
import '../shared/device_service.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeviceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<ServiceHost> _deviceList = [];
  DeviceDiscoveryService _discoveryService;

  _DeviceListState() {
    _discoveryService = new DeviceDiscoveryService((ServiceHost device) {
      // on device added
      setState(() {
        if (!_deviceList.any((d) => d.host == device.host)) {
          _deviceList.add(device);
        }
      });
    }, (String name) {
      setState(() {
        _deviceList.removeWhere((d) => d.name == name);
      });
    });

    _discoveryService.startListening();
  }

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: false,
        padding: const EdgeInsets.all(20.0),
        children: _deviceList.map((ServiceHost d) {
          return new DeviceListItem.fromServiceHost(d);
        }).toList(),
      );
}

class DeviceListItem extends StatefulWidget {
  final String name;
  final String host;
  final int port;

  DeviceListItem({this.name, this.host, this.port});
  DeviceListItem.fromServiceHost(ServiceHost device)
      : name = device.name,
        host = device.host,
        port = device.port;

  @override
  State<StatefulWidget> createState() => _DeviceListItemState();
}

class _DeviceListItemState extends State<DeviceListItem> {
  bool _on = false;
  DeviceService _service;

  _DeviceListItemState() {
    _service = new DeviceService(widget.name, widget.host, widget.port);
    _service.getStrip().then((StripDto strip) {
      _on = strip.state == 'on';
    });
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
            _on ? FontAwesomeIcons.lightbulb : FontAwesomeIcons.lightbulbO),
        title: Text(widget.name),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) {
              return new DeviceInformationPage(deviceService: _service);
            }),
          );
        },
      );
}
