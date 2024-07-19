import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:MinuteNews/main_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),()=>
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage())));
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Daily News'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Image.asset("Images/splash_pic.jpg"),
        SpinKitCircle(
          color: Colors.grey,
          size: 50.0,
        ),
          ],
        ),
      ),
    );
  }
}
