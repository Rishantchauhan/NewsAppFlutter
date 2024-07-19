import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
   final String? title;
   final String? Description;
   final String? ImageUrl;
   final String? Url;
   final String? author;
   final String? date;

  const NewsItem({required this.title,required this.author,required this.date,required this.Description,required this.ImageUrl,required this.Url,super.key});

  @override
  Widget build(BuildContext context) {
    var max_h=MediaQuery.of(context).size.height;
    var max_w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
         title: Text('News'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Container(
               color: Colors.white12,
               height: max_h*0.4,
               width: max_w,
               child: ImageUrl!=null?Image.network(ImageUrl!):Image.asset('Images/temp.png'),
             ),
             ListTile(
               leading: Icon(Icons.person),
               title: Text('Author: ' + (author!=null?author!:' ')),
             ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Published At: ' + (date!=null?date!:" ")),
            ),
             ListTile(
               title: Text(title!=null?title!:' ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
               subtitle:Text(Description!=null?Description!:" "),
               ),

             Url!=null?InkWell(
               onTap: (){
                   _launchURL(Url.toString());
                   print('Button');
               },
               child: Text('Read Full News', style:  TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.lightBlue,
               ),),
             ):
            SizedBox(
              height: 20,
            ),



          ],
            ),
      ),
          

    );
  }
}
void _launchURL(String url1) async {
  final Uri url = Uri.parse(url1);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}