import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quotes/Screens/category.dart';
import 'package:quotes/Screens/favorites.dart';
import 'package:quotes/Database/quotesDatabase.dart';

TextStyle headingStyle = TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500);
List<Color> colors = [Color(0xffe3f0ff),Color(0xffffefd7),Color(0xfffffef9),Color(0xffd2e7ff),Color(0xfffff6e9),Color(0xfff4e7e7),Color(0xffcecbcb), Color(0xffcbdadb), Color(0xff96ceb4),Color(0xfffff4e6)];


class HomePage extends StatelessWidget {
  final int index = Random().nextInt(randomQuote.length);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'), fit: BoxFit.cover)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(icon: Icon(Icons.favorite, color: Colors.white, size: 35), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteQuotes(),));
                },),
              ),

              Text("Quote of the day" ,style: headingStyle,),

              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/quoteoftheday.jpeg'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20)
                ),                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${randomQuote[index]['quote']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.black),),
                    SizedBox(height: 10,),
                    Align(child: Text('~ ${randomQuote[index]['author']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),), alignment: Alignment.bottomRight,)
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top:20.0, bottom: 10),
                child: Text("Categories" ,style: headingStyle,),
              ),

              Center(
                child: Wrap(
                  children: quotesDatabase.map((e) => buildCategory(e, context)).toList().cast<Widget>()
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget  buildCategory(Map category, BuildContext context){
    int index = categories.indexOf(category['name']) % colors.length;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context )=> CategoryPage(category)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: colors[index],borderRadius: BorderRadius.circular(15)),
        alignment: Alignment.center,
        height: 70,
        width: MediaQuery.of(context).size.width/2 - 40,
        child: Text(category['name'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}