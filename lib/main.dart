import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listados_star_wars/model/people_response.dart';
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
  
  late Future<List<Person>> people;

  @override
  void initState() {
    planets = fetchPlanets();
    people = fetchPeople();
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
                      _planetList(snapshot.data!)
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
            child: FutureBuilder<List<Person>>(
              future: people,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text('People'),
                      _peopleList(snapshot.data!)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }
            )
          )
        ],
      ),
    );
  }

  Widget _planetList(List list) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _planetItem(list.elementAt(index), index);
        }
      ),
    );
  }

  Widget _peopleList(List list) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _personItem(list.elementAt(index), index);
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(planet.name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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

  Widget _personItem(Person planet, int index) {
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(planet.name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              child: Image.network(
                'https://starwars-visualguide.com/assets/img/characters/${index + 1}.jpg',
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

  Future<List<Person>> fetchPeople() async{
    final response = await http.get(Uri.parse('https://swapi.dev/api/people'));
    if (response.statusCode == 200) {
      return PeopleResponse.fromJson(jsonDecode(response.body)).results;
    }else {
      throw Exception('Failed to load planets');
    }
  }


}