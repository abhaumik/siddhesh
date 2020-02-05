import 'package:flutter/material.dart';
import 'myflexiableappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Search(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        backgroundColor: Colors.black,
        primaryColor: Colors.black,
        cardColor: Colors.black,
      ),
    );
  }
}

class Search extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int nImages = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.black,
              floating: true,
              pinned: false,
              expandedHeight: 280.0,
              flexibleSpace: FlexibleSpaceBar(
                background: MyFlexiableAppBar(),
              )),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    nImages = snapshot.data.documents.length;
                    return SliverList(
                        delegate:
                            SliverChildBuilderDelegate((context, int index) {
                      if (nImages == 0) {
                        return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(40),
                            child: Card(
                                child: Container(
                                    padding: EdgeInsets.all(40),
                                    child: Center(child: Text("No Images")))));
                      } else {
                        DocumentSnapshot myPost =
                            snapshot.data.documents[index];
                        return Card(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: '${myPost['image']}',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                    }, childCount: nImages));
                  } else {
                    return SliverList(
                        delegate:
                            SliverChildBuilderDelegate((context, int index) {
                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(40),
                          child: Card(
                              child: Container(
                                  padding: EdgeInsets.all(40),
                                  child: Center(
                                      child: Text("${snapshot.error}")))));
                    }, childCount: 1));
                  }
                } else {
                  return SliverList(
                      delegate:
                          SliverChildBuilderDelegate((context, int index) {
                    return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(40),
                        child: Card(
                            child: Container(
                                padding: EdgeInsets.all(40),
                                child: Center(
                                    child: CircularProgressIndicator()))));
                  }, childCount: 3));
                }
              })
        ],
      ),
    );
  }
}
