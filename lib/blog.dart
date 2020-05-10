import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class Blog extends StatefulWidget {

  final String id;

  Blog(this.id);


  @override
  _BlogState createState() => _BlogState(id);
}

class _BlogState extends State<Blog> {

  final String ID;

  _BlogState(this.ID);


  Future<Album> futureAlbum;
  var isLoading = false;

  Future<Album> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get("https://www.fakestoday.com/_functions/blog/"+ID);
    if (response.statusCode == 200) {

      setState(() {
        isLoading = false;
      });

      return Album.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum = _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("blog"),
        ),

        body: SingleChildScrollView(
        child:
         Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(ID),
                        Text(snapshot.data.title),
                        Image.network(
                          snapshot.data.thumbnailUrl,
                          fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0,
                        ),
                        Text(snapshot.data.id),
                        Text(snapshot.data.text),



                      ],
                    ),
                  ),
                );




              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),

    )
    );
  }
}





class Album {
  final String title;
  final String thumbnailUrl;
  final String id;
  final String text;

  Album._({this.title, this.thumbnailUrl,this.id,this.text});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album._(
        title: json['title'],
        thumbnailUrl: json['coverImage'],
        id: json['_id'],
        text: json['plainContent']
    );
  }
}