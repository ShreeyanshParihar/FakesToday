import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fakestoday/blog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'blogtheme.dart';

class Real extends StatefulWidget {
  @override
  _RealState createState() => _RealState();
}

class _RealState extends State<Real> {

  List<Photo> real = List();

  var isLoading = false;

  fetchall() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get("https://www.fakestoday.com/_functions/post/Real");
    if (response.statusCode == 200) {
      real = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos do something');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchall();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
        body: Center(
          child: FlareActor(
            "assets/Fakes_Today.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "Loading",
          ),
        ))
        : Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'All Real News',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: DesignCourseAppTheme.nearlyBlue,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height *3 ,
                        child: ListView.builder(
                            itemCount: real.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return
                                Card(
                                  child: ListTile(
                                    leading: CachedNetworkImage(
                                      imageUrl: real[index].thumbnailUrl,
                                      fit: BoxFit.cover,
                                      height: 80.0,
                                      width: 80,
                                      filterQuality: FilterQuality.none,
                                    ),
                                    title: Text(real[index].title),
                                    subtitle: Text(real[index].cat),
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Blog(real[index].id)));
                                    },
                                  ),
                                );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Fakes Today',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}



class Photo {
  final String title;
  final String thumbnailUrl;
  final String id;
  final String cat;

  Photo._({this.title, this.thumbnailUrl, this.id, this.cat});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo._(
        title: json['Title'],
        thumbnailUrl: json['CoverImg'],
        id: json['ID'],
        cat: json['Category']);
  }
}
