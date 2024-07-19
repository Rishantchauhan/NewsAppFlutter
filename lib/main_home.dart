import 'dart:convert';

import 'package:MinuteNews/newsitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:MinuteNews/category_screen.dart';
import 'package:http/http.dart' as http;
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool fetching = false;
  String name = 'in';

  // String selected='in';
  List<dynamic> _articles = [];

  Future<void> getData() async {
    //print(selected);

    // var url = Uri.parse("https://newsapi.org/v2/top-headlines?country=$name&apiKey=11f806c2da054911a0c81c5951518e62");
    // var url = Uri.parse("https://saurav.tech/NewsAPI/top-headlines/category/general/$name.json");
    var url=Uri.parse('https://newsdata.io/api/1/latest?apikey=pub_42247445081fb6c54091aa9269ed19e660ece&q=cryptocurrency&country=$name&language=en');
    fetching = true;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          if(jsonData['results'].length>0) {
             print('Inside if');
             print(jsonData['results']);
            _articles = jsonData['results'];
            fetching = false;
            print(_articles);
          }
        });
        print(jsonData);
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('fetched');
    fetching = false;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 6,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()));
            },
            icon: Image.asset('Images/category_icon.png'),
          ),
          title: Center(child: Text('Welcome To Daily News')),
          actions: [
            Text(name.toUpperCase()),
            PopupMenuButton(
                onSelected: (item) {
                  setState(() {
                    name = item;
                    getData();
                  });
                },
                itemBuilder: (context) =>
                [
                  PopupMenuItem(child: Text('IN'), value: 'in',),
                  PopupMenuItem(child: Text('US'), value: 'us',),
                ]),

          ],
        ),
        body: fetching == false ?

        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>NewsItem(title: _articles[index]['title'],
                          author: _articles[index]['creator']!=null?_articles[index]['creator'][0]:null,
                          date: _articles[index]['pubDate'],
                          Description: _articles[index]['description'],
                          ImageUrl: _articles[index]['image_url'],
                          Url: _articles[index]['link'],
                      )
                  ),

                  );

                },
                child: Card(
                  shadowColor: Colors.grey,
                  elevation: 4,
                  child: Container(
                    color: Colors.white10.withOpacity(0.7),
                    width: 20,
                    height: 60,
                    // Add height for better visibility
                    alignment: Alignment.center,
                    // Center content in the container
                    child: Stack(children: [
                      Positioned(
                          bottom: 30,
                          // Adjust this value to position the text relative to the bottom
                          left: 0,
                          // Optionally adjust left position
                          right: 0,
                          child: Image.network(_articles[index]['image_url'] !=
                              null
                              ? _articles[index]['image_url']
                              : "https://images.news18.com/ibnlive/uploads/2024/06/untitled-design-66-2024-06-f546046ba7453a739549f6fcf4152597-16x9.jpg")),

                      Positioned(
                        bottom: 20,
                        // Adjust this value to position the text relative to the bottom
                        left: 0,
                        // Optionally adjust left position
                        right: 0,
                        top: 20,
                        child: Text(_articles[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]
                    ),
                  ),
                ),
              );
            }
        ) : Center(child: SpinKitWave(
          color: Colors.grey,
          size: 50.0,
        )),
      ),
    );
  }
}