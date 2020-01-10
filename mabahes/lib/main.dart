import 'package:flutter/material.dart';
import 'backdrop.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
          accentColor: Colors.blueGrey[900],
        ),
        home: Backdrop());
  }
}
