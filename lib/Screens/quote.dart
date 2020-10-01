import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotes/Screens/favorites.dart';
import 'package:quotes/Database/db.dart';

class QuotePage extends StatefulWidget {
  final int index;
  final String category;
  final List<String> quotes;
  final bool isFav;
  QuotePage(this.index, this.quotes, this.category, {this.isFav});
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  int idx;
  @override
  void initState() {
    idx = widget.index;
    super.initState();
  }
  bool playing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'), fit: BoxFit.cover)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Icon(Icons.content_copy,size: 30, color: Colors.white,)),
                  onTap: (){
                    Clipboard.setData(new ClipboardData(text: "${widget.quotes[idx%widget.quotes.length].split('-')[0].toString()} - ${widget.quotes[idx%widget.quotes.length].split('-')[1].toString()}")); 
                  },
                ),
                FutureBuilder(
                  future: DBHelper().isFavourite(widget.quotes[idx%widget.quotes.length].split('-')[0] + "-" + widget.quotes[idx%widget.quotes.length].split('-')[1] + "-" + widget.category),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                    return InkWell(
                      onTap: (){
                        if(widget.isFav == true){
                          setState((){
                            DBHelper().removeFavourite(widget.quotes[idx%widget.quotes.length].split('-')[0] + "-" + widget.quotes[idx%widget.quotes.length].split('-')[1] + "-" + widget.quotes[idx%widget.quotes.length].split('-')[2]);
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> FavoriteQuotes()));
                          });                      
                        }
                        else{
                          setState(() {
                            snapshot.data.length > 0 ? DBHelper().removeFavourite(widget.quotes[idx%widget.quotes.length].split('-')[0] + "-" + widget.quotes[idx%widget.quotes.length].split('-')[1] + "-" + widget.category) :
                            DBHelper().save(widget.quotes[idx%widget.quotes.length].split('-')[0] + "-" + widget.quotes[idx%widget.quotes.length].split('-')[1] + "-" + widget.category);
                          });
                        }                    
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: widget.isFav == true? Icon(Icons.favorite, color: Colors.white,size: 50,) :snapshot.data.length > 0 ? Icon(Icons.favorite, color: Colors.white,size: 50,) : Icon(Icons.favorite_border,size: 50, color: Colors.white,),
                      ),
                    );
                    }
                    else 
                    {
                      return Align(
                      alignment: Alignment.bottomRight,
                      child:Icon(Icons.favorite_border,size: 50, color: Colors.white,)
                      );
                    }
                  }),
              ],
            ),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height -250,
              width: double.infinity,
              child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.quotes[idx%widget.quotes.length].split('-')[0], style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Align(child: Text(widget.quotes[idx%widget.quotes.length].split('-')[1], style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic, color: Colors.blueGrey, fontSize: 15),), alignment: Alignment.bottomRight,)
                      ],
                    ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  padding: EdgeInsets.only(left:10),
                  icon: Icon(Icons.keyboard_arrow_left, size: 50, color: Colors.white),
                  onPressed: (){
                    setState(() {
                      idx--;
                    });
                  },
                ),

                IconButton(
              icon: playing ? Icon(Icons.stop,size: 50, color: Colors.white) : Icon(Icons.play_arrow,  color: Colors.white,size: 50),
              onPressed: (){
                  setState(() {
                    playing = !playing;
                  });

                  Timer.periodic(Duration(seconds:2), (Timer timer){
                    if(playing){
                      setState(() {
                        playing = true;
                        idx++;
                      });
                    }
                    else{
                      timer.cancel();
                    }
                    
                    
                  });
              },
            ),

                IconButton(
              icon: Icon(Icons.keyboard_arrow_right,size: 50, color: Colors.white,),
              onPressed: (){
                setState(() {
                  idx++;
                });
              },
            ),
            
              ],
            ),
            
          ],
      ),
        ),
    );
  }
}