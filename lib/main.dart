import 'package:flutter/material.dart';

import 'device/pages/device_search.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Colorz',
      theme: new ThemeData(
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          )
        ),
        primarySwatch: Colors.lightBlue,
      ),
      home: new DeviceSearchPage(title: 'Colorz'),
    );
  }
}
