import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pandanews/category_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pandanews/newsitem.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool fetching=false;
  String name='in';
  // String selected='in';
  List<dynamic> _articles = [];
  Future<void> getData() async {
    //print(selected);

    var url = Uri.parse("https://newsapi.org/v2/top-headlines?country=$name&apiKey=11f806c2da054911a0c81c5951518e62");
    fetching=true;
    try {

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _articles = jsonData['articles'];
          fetching=false;
        });
        print(jsonData);
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('fetched');
    fetching=false;
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
          leading: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryScreen()));
            },
            child: Image.asset('Images/category_icon.png',height: 2),
          ),
          title: Center(child: Text('Welcome To Daily News')),
          actions: [
            Text(name.toUpperCase()),
            PopupMenuButton(
                onSelected: (item){
                   setState(() {
                     name=item;
                     getData();
                   });
                },
                itemBuilder:(context)=>[
               PopupMenuItem(child: Text('IN'),value: 'in',),
               PopupMenuItem(child: Text('US'),value: 'us',),
            ]),

          ],
        ),
        body:fetching==false?

         GridView.builder(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               crossAxisSpacing: 10.0,
               mainAxisSpacing: 10.0,
               childAspectRatio: 0.75,
             ),
             itemCount: _articles.length,
             itemBuilder: (context,index){
           return InkWell(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItem(title: _articles[index]['title'], author: _articles[index]['author'], date: _articles[index]['publishedAt'], Description: _articles[index]['description'], ImageUrl: _articles[index]['urlToImage'], Url:_articles[index]['url']))
               );
             },
             child: Card(
               shadowColor: Colors.grey,
               elevation: 4,
               child: Container(
                 color: Colors.white10.withOpacity(0.7),
                 width: 20,
                 height: 60, // Add height for better visibility
                 alignment: Alignment.center, // Center content in the container
                 child: Stack(children: [
                   Positioned(
                       bottom: 30, // Adjust this value to position the text relative to the bottom
                       left: 0, // Optionally adjust left position
                       right: 0,
                       child: Image.network(_articles[index]['urlToImage']!=null?_articles[index]['urlToImage']:"https://images.news18.com/ibnlive/uploads/2024/06/untitled-design-66-2024-06-f546046ba7453a739549f6fcf4152597-16x9.jpg")),

                   Positioned(
                       bottom: 20, // Adjust this value to position the text relative to the bottom
                       left: 0, // Optionally adjust left position
                       right: 0,
                       top: 20,
                       child:Text(_articles[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),)),
                 ]
               ),
               ),
             ),
           );
         }
                ):Center(child: SpinKitWave(
          color: Colors.blue,
          size: 50.0,
        )),
      ),
    );
  }

  // Future<void> getDate() async{
  //   print('fetching');
  //   var url=Uri.parse("https://newsapi.org/v2/top-headlines?country=us&apiKey=11f806c2da054911a0c81c5951518e62");
  //   final data= await http.get(url);
  //   if(data.statusCode==200)
  //    {
  //      var jsondata=jsonDecode(data.body);
  //      print(jsondata);
  //      print('fetched');
  //    }
  //   else{
  //      print('Some Error');
  //   }

  //   // setState(() {
  //   //   data=jsondata['articles'];
  //   // });
  }
