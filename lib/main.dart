import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'blog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MainFetchData()
    );
  }
}


class MainFetchData extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<MainFetchData> {
  List<Photo> list = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("https://www.fakestoday.com/_functions/latest/Real");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fetch Data JSON"),
        ),

        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text(list[index].title+" "+list[index].id),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Blog(list[index].id) ) )
                } ,
                trailing: Image.network(
                  list[index].thumbnailUrl,
                  fit: BoxFit.cover,
                  height: 40.0,
                  width: 40.0,
                ),
              );
            }));
  }
}

class Photo {
  final String title;
  final String thumbnailUrl;
  final String id;
  
  Photo._({this.title, this.thumbnailUrl,this.id});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo._(
      title: json['Title'],
      thumbnailUrl: json['CoverImg'],
      id: json['ID']
    );
  }
}
