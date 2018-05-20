import '../components/device_list.dart';

import 'package:flutter/material.dart';

class DeviceSearchPage extends StatelessWidget {
  final String title;

  DeviceSearchPage({this.title});

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: DeviceList(),
      );

}