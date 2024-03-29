import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'blogtheme.dart';
import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';

class Blog extends StatefulWidget {

  final String id;

  Blog(this.id);

  @override
  _BlogState createState() => _BlogState(id);
}

class _BlogState extends State<Blog>
    with TickerProviderStateMixin {

  final String ID;

  _BlogState(this.ID);

  Future<Album> futureAlbum;
  var isLoading = false;

  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;



  @override
  void initState() {

    futureAlbum = _fetchData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }



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



    _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

   _shareImageFromUrl(String img,String title,String url,String cat) async {


     final RenderBox box = context.findRenderObject();
     Share.share(cat+":"+title+"\nRead more at "+url+"\n\nOr download android app from www.fakestoday.com",
         subject: "fakestoday.com : "+title,
         sharePositionOrigin:
         box.localToGlobal(Offset.zero) &
         box.size);



//    try {
//      var request = await HttpClient().getUrl(Uri.parse(img));
//      var response = await request.close();
//      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//      await Share.file('Fakes Today', 'img.jpg', bytes, '*/*',text:cat +" : "+ title +" "+url+"\n\n\n www.fakestoday.com \nTo keep yourself updated and more exciting stories, Download Fakes Today app using from our official website." );
//    } catch (e) {
//      print('error: $e');
//    }
  }




  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.height/5)  ;
    return isLoading
        ?
     Container(
      color: DesignCourseAppTheme.nearlyWhite,
       child:Center(
         child: FlareActor("assets/Fakes_Today.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Loading",
      ) ,
     )
     ):


    FutureBuilder<Album>(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.transparent,

            child: Scaffold(
              backgroundColor: DesignCourseAppTheme.nearlyWhite,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: BackButton(color: DesignCourseAppTheme.nearlyBlack,),
                    actions: <Widget>[
                      Card(
                        color: DesignCourseAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 20.0,
                        child: GestureDetector(
                          onTap: ()  {
                            _launchInBrowser(snapshot.data.url);
                          },
                          child:Container(
                            width: 70,
                            height: 40,
                            child: Center(
                                child: Text("Web",style: TextStyle(color: DesignCourseAppTheme.nearlyWhite),)
                            ),
                          ),
                        ),
                      ),


                      Card(
                        color: DesignCourseAppTheme.nearlyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 20.0,
                        child: GestureDetector(
                          onTap: () async {
                            await _shareImageFromUrl(snapshot.data.thumbnailUrl, snapshot.data.title,
                                snapshot.data.url,snapshot.data.cat);
                          },
                          child:Container(
                            width: 50,
                            height: 40,
                            child: Center(
                              child: Icon(
                                Icons.share  ,
                                color: DesignCourseAppTheme.nearlyWhite,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                    expandedHeight: MediaQuery.of(context).size.height * 0.5,
                    backgroundColor: Colors.transparent,

                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: snapshot.data.thumbnailUrl,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.low,
                      ),
                    ),
                  ),
                  SliverList(

                    delegate: SliverChildListDelegate(
                      <Widget>[

                        Container(

                          decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyWhite,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.grey.withOpacity(0.7),
                                  offset: const Offset(2,2),
                                  blurRadius: 20.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: SingleChildScrollView(
                              child: Container(
                                constraints: BoxConstraints(
                                    minHeight: infoHeight,
                                    maxHeight: tempHeight > infoHeight
                                        ? tempHeight
                                        : infoHeight),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[


                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 32.0, left: 18, right: 16),
                                      child: Text(
                                        snapshot.data.title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 8, top: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[

                                          Text(
                                            snapshot.data.date,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 16,
                                              letterSpacing: 0.27,
                                              color: DesignCourseAppTheme.nearlyBlue,
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data.cat,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 22,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme.grey,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: DesignCourseAppTheme.nearlyBlue,
                                                  size: 24,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    Expanded(

                                      child:SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 8, bottom: 8),
                                          child: Text(
                                            snapshot.data.text,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 0.27,
                                              color: DesignCourseAppTheme.nearlyBlack,
                                            ),

                                          ),
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
                  ),



                ],
              ),






            ),

          );

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Container(child: FlareActor("assets/Fakes_Today.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Loading",
        ) ,
        );

      },
    );
  }


}


class Album {
  final String title;
  final String thumbnailUrl;
  final String id;
  final String text;
  final String date;
  final String cat;
   final String url;

  Album._({this.title, this.thumbnailUrl,this.id,this.date,this.text,this.cat,this.url});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album._(
        title: json['title'],
        thumbnailUrl: json['coverImage'],
        id: json['_id'],
        text: json['plainContent'],
        date:  Date( json['publishedDate']),
        cat: json['categories'],
        url: json['postPageUrl']
    );
  }
}

String Date(String d) {
  final now = DateTime.parse(d);
  final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  return  DateFormat("dd/MM/yyyy - HH:mm").format(dt);
}
