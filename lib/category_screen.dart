import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:pandanews/newsitem.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool fetching=false;
  List<String>category=[
    'business','entertainment','general','health','science','sports','technology'];
  List<dynamic>Data=[];
  // String Title="Top 10 Best Rank Tracker Tools of 2024";
  // String Description="It’s one thing to have good website copy — it’s something entirely different to ensure your site has great copy (and design) and also ranks well on Google.";
  String Category_selected='general';


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
      print('int');
      fetchdata();
      print('Out');
  }
  Future<void> fetchdata() async
  {
     var url=Uri.parse("https://newsapi.org/v2/top-headlines?country=in&category=$Category_selected&apiKey=11f806c2da054911a0c81c5951518e62");
     fetching=true;
     final response=await http.get(url);
     // print('\n');
     var data=jsonDecode(response.body);
     // print('\n');
     // print(data);
     setState(() {
        Data=data['articles'];
        fetching=false;
     });


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
                             fetchdata();

                          });
                        },
                        child: Text(category[index][0].toUpperCase()+category[index].substring(1),
                        style: TextStyle( color: Category_selected==category[index]?Colors.lightBlue:Colors.black,))


                      );

               }),
          ),
          Expanded(child:ListView.builder(
              itemCount: Data.length,
              itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItem(title: Data[index]['title'], Description:Data[index]['description'], ImageUrl:Data[index]['urlToImage'] , Url:Data[index]['url'],author: Data[index]['author'],date:Data[index]['publishedAt'])));
                    },
                    child: Container(
                      margin:EdgeInsets.all(1),
                      height: 100,
                      child: ListTile(
                         leading: Image.network(Data[index]['urlToImage']==null?'https://images.moneycontrol.com/static-mcnews/2023/10/2-tata-steel.jpg':Data[index]['urlToImage'],height: 100,width:100),
                          title: Text(Data[index]['title']==null?'No Title To Show':Data[index]['title'].length>28?Data[index]['title'].substring(0,28)+'...':Data[index]['title'],style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(Data[index]['description']==null?'No Description to show':Data[index]['description'].length>80?Data[index]['description'].substring(0,80)+'...':Data[index]['description']),
                      ),
                    ),
                  );
          }))
        ],
      ):Center(child: SpinKitWave(
        color: Colors.blue,
        size: 50.0,
      )),
    );
  }
}
