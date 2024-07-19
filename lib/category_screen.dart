import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:MinuteNews/newsitem.dart';
import 'package:provider/provider.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool fetching=false;
  List<String>category=[
  'top','business','entertainment','health','science','sports','technology'];
  List<dynamic>_articles=[];
  // String Title="Top 10 Best Rank Tracker Tools of 2024";
  // String Description="It’s one thing to have good website copy — it’s something entirely different to ensure your site has great copy (and design) and also ranks well on Google.";
  String Category_selected='top';

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
      print('int');
      fetch_articles();
      print('Out');
  }
  Future<void> fetch_articles() async
  {
    var url=Uri.parse('https://newsdata.io/api/1/latest?apikey=pub_42247445081fb6c54091aa9269ed19e660ece&category=$Category_selected&country=in&language=en');
    fetching = true;
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json_articles = jsonDecode(response.body);
        setState(() {
          if(json_articles['results'].length>0) {
            print('Inside if');
            print(json_articles['results']);
            _articles = json_articles['results'];
            fetching = false;
            print(_articles);
          }
        });
        print(json_articles);
      } else {
        print('Failed to load _articles');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('fetched');
    fetching = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body:fetching==false?Column(
        children: [
          SizedBox(
            height: 50,
            child:
               ListView.builder(
                   itemCount: category.length,
                   scrollDirection: Axis.horizontal,
                   itemBuilder: (context,index){
                      return TextButton(
                        onPressed: (){
                          setState(() {
                             Category_selected=category[index];
                             fetch_articles();

                          });
                        },
                        child: Text(category[index][0].toUpperCase()+category[index].substring(1),
                        style: TextStyle( color: Category_selected==category[index]?Colors.lightBlue:Colors.black,))


                      );

               }),
          ),
          Expanded(child:ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItem(title: _articles[index]['title'],
                         author: _articles[index]['creator']!=null?_articles[index]['creator'][0]:null,
                         date: _articles[index]['pubDate'],
                         Description: _articles[index]['description'],
                         ImageUrl: _articles[index]['image_url'],
                         Url: _articles[index]['link'],
                       )
                      ));
                    },
                    child: Container(
                      margin:EdgeInsets.all(1),
                      height: 100,
                      child: ListTile(
                         leading: Image.network(_articles[index]['image_url']==null?'https://images.moneycontrol.com/static-mcnews/2023/10/2-tata-steel.jpg':_articles[index]['image_url'],height: 100,width:100),
                          // title: Text(_articles[index]['title']==null?'No Title To Show':_articles[index]['title'].length>28?_articles[index]['title'].substring(0,28)+'...':_articles[index]['title'],style: TextStyle(fontWeight: FontWeight.bold)),
                         title: Text(_articles[index]['title']==null?'No Title To Show':_articles[index]['title'],
                             style: TextStyle(fontWeight: FontWeight.bold),
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                         ),
                        subtitle: Text(_articles[index]['description']==null?'No Description to show':_articles[index]['description'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
          }))
        ],
      ):Center(child: SpinKitWave(
        color: Colors.grey,
        size: 50.0,
      )),
    );
  }
}
