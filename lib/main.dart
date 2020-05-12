import 'dart:convert';
import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fakestoday/allnews.dart';
import 'package:fakestoday/blog.dart';
import 'package:fakestoday/fake.dart';
import 'package:fakestoday/real.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import "package:flare_flutter/flare_actor.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blogtheme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
        title: 'Fakes Today',
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

        ),
        home: Latest()
    );
  }
}


class Latest extends StatefulWidget {
@override
_LatestState createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  CategoryType categoryType;
  List<Photo> fake = List();
  List<Photo> real = List();
  List<Photo> latest = List();

  var isLoading = false;

  _fetchReal() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get("https://www.fakestoday.com/_functions/latest/Real");
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


  _fetchFake() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get("https://www.fakestoday.com/_functions/latest/Fake");
    if (response.statusCode == 200) {
      fake = (json.decode(response.body) as List)
          .map((data) => new Photo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos do something');
    }
  }

  _fetchLatest() async {
    setState(() {
      isLoading = true;
    });

    final response =
    await http.get("https://www.fakestoday.com/_functions/latest");
    if (response.statusCode == 200) {
      latest = (json.decode(response.body) as List)
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
    _fetchReal();
    _fetchFake();
    _fetchLatest();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
      body:Center(
      child: FlareActor("assets/Fakes_Today.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Loading",
      ) ,
    ) ): Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                            child: Text(
                              "Latest Fake News",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 100,
                            child:ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: fake.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllNews() ) );
                                    },

                                    //Blog(fake[index].id)
                                    child: SizedBox(
                                      width: 300,

                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: DesignCourseAppTheme.notWhite,
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(16.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const SizedBox(
                                                          width: 48 + 24.0,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(top: 16),
                                                                  child: Text(
                                                                    fake[index].title,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 12,
                                                                      color: DesignCourseAppTheme
                                                                          .darkerText,
                                                                    ),
                                                                  ),
                                                                ),


                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 40),
                                              child: Row(
                                                children: <Widget>[
                                                  ClipRRect(
                                                      borderRadius:
                                                      const BorderRadius.all(Radius.circular(16.0)),
                                                      child: AspectRatio(
                                                        aspectRatio: 0.75,
                                                        child: CachedNetworkImage(
                                                          imageUrl: fake[index].thumbnailUrl,
                                                          fit: BoxFit.cover,
                                                          height: 40.0,
                                                          width: 40.0,
                                                          filterQuality: FilterQuality.none,
                                                        ),
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ),
                          ),

                        ],
                      ),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                            child: Text(
                              "Latest Real News",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 100,
                            child:ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: real.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => Blog(real[index].id) ) );
                                    },
                                    child: SizedBox(
                                      width: 300,

                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 48,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: DesignCourseAppTheme.notWhite,
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(16.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const SizedBox(
                                                          width: 48 + 24.0,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(top: 16),
                                                                  child: Text(
                                                                    real[index].title,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 12,
                                                                      color: DesignCourseAppTheme
                                                                          .darkerText,
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 40),
                                              child: Row(
                                                children: <Widget>[
                                                  ClipRRect(
                                                      borderRadius:
                                                      const BorderRadius.all(Radius.circular(16.0)),
                                                      child: AspectRatio(
                                                        aspectRatio: 0.75,
                                                        child: CachedNetworkImage(
                                                          imageUrl: real[index].thumbnailUrl,
                                                          fit: BoxFit.cover,
                                                          height: 40.0,
                                                          width: 40.0,
                                                          filterQuality: FilterQuality.none,
                                                        ),
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ),
                          ),

                        ],
                      ),

                      SingleChildScrollView(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'All Highlights',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme.darkerText,
                                ),
                              ),

                              SizedBox(
                                  height: 480,
                                  child:ListView.builder(
                                      itemCount: latest.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return  Card(
                                          child: ListTile(
                                            leading: CachedNetworkImage(
                                              imageUrl: latest[index].thumbnailUrl,
                                              fit: BoxFit.cover,
                                              height: 80.0,
                                              width: 80,
                                              filterQuality: FilterQuality.none,
                                            ),
                                            title: Text(latest[index].title),
                                            subtitle: Text(latest[index].cat,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold ),),
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Blog(latest[index].id)));
                                            },
                                          ),
                                        );
                                      })
                              ),

                            ],
                          ),

                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }









  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.all == categoryTypeData) {
      txt = 'All';
    } else if (CategoryType.fake == categoryTypeData) {
      txt = 'Fake';
    } else if (CategoryType.real == categoryTypeData) {
      txt = 'Real';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
                switch(txt){
                  case "All": Navigator.push(context, MaterialPageRoute(builder: (context) => AllNews() ) );
                              break;
                  case "Fake":Navigator.push(context, MaterialPageRoute(builder: (context) => Fake() ) );
                         break;
                  case "Real":Navigator.push(context, MaterialPageRoute(builder: (context) => Real() ) );
                }

              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                children: <Widget>[
                  Expanded(
                    flex : 3,
                    child:Text(
                    'Fakes Today',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.27,
                      color: DesignCourseAppTheme.darkerText,
                    ),
                  ),
                  ),

                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color:DesignCourseAppTheme.nearlyBlue,
                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white24,
                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                            onTap: () {
                              _launchInBrowser();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 6, bottom: 6, left: 9, right: 9),
                              child: Center(
                                child: Text(
                                  "Website",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.27,
                                    color:DesignCourseAppTheme.nearlyWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),

                  Expanded(
                     flex: 0,
                    child: IconButton(
                      alignment: Alignment.topRight,
                    icon: Icon(Icons.share),
                      onPressed: () {   _shareImageFromUrl();  },
                  )
                  )

                ],
              ),




                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: <Widget>[
                      getButtonUI(CategoryType.all, categoryType == CategoryType.all),
                      const SizedBox(
                        width: 16,
                      ),
                      getButtonUI(
                          CategoryType.fake, categoryType == CategoryType.fake),
                      const SizedBox(
                        width: 16,
                      ),
                      getButtonUI(
                          CategoryType.real, categoryType == CategoryType.real),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
                  child: Text(
                    'All Latest News',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 0.27,
                      color: DesignCourseAppTheme.darkerText,
                    ),
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

enum CategoryType {
  all,
  fake,
  real,
}


class Photo {
  final String title;
  final String thumbnailUrl;
  final String id;
  final String cat;

  Photo._({this.title, this.thumbnailUrl,this.id,this.cat});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo._(
        title: json['Title'],
        thumbnailUrl: json['CoverImg'],
        id: json['ID'],
        cat: json['Category']
    );
  }
}

_shareImageFromUrl()  async {
  try {
    final ByteData bytes = await rootBundle.load('assets/app_icon.png');
    await Share.file(
        'Fakes Today', 'fakestoday.png', bytes.buffer.asUint8List(), 'image/png', text: 'Download Fakes Today app using the link.');
  } catch (e) {
    print('error: $e');
  }
}

_launchInBrowser() async {
  if (await canLaunch("https://www.fakestoday.com")) {
    await launch(
      "https://www.fakestoday.com",
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch fakestoday.com';
  }
}