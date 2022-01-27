import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const (),
    );
  }
}

class ListsPage extends StatefulWidget {
  const ListsPage({ Key? key }) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: ListView(
              children: [
                
              ],
            ),
          ),
          Container(

          )
        ],
      ),
    );
  }
}