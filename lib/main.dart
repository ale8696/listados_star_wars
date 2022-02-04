import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listados_star_wars/model/planets_response.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListsPage(),
    );
  }
}

class ListsPage extends StatefulWidget {
  const ListsPage({ Key? key }) : super(key: key);

  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {

  late Future<List<Planet>> planets;

  @override
  void initState() {
    planets = fetchPlanets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: FutureBuilder<List<Planet>>(
              future: planets,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text('Planets'),
                      _itemList(snapshot.data!)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }
            )
          ),
          Container(
            
          )
        ],
      ),
    );
  }

  Widget _itemList(List list) {
    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _planetItem(list.elementAt(index), index);
        }
      ),
    );
  }

  Widget _planetItem(Planet planet, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(planet.name),
            ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              child: Image.network(
                'https://starwars-visualguide.com/assets/img/planets/${index + 1}.jpg',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.network(
                    'https://starwars-visualguide.com/assets/img/placeholder.jpg',
                    height: 200,
                    fit: BoxFit.cover
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Planet>> fetchPlanets() async{
    final response = await http.get(Uri.parse('https://swapi.dev/api/planets'));
    if (response.statusCode == 200) {
      return PlanetsResponse.fromJson(jsonDecode(response.body)).results;
    }else {
      throw Exception('Failed to load planets');
    }
  }


}