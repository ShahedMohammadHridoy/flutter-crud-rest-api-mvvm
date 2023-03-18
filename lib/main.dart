import 'package:flutter/material.dart';
import 'home_page.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      title: 'CRUD with REST API (MVVM)',
    );
  }

}