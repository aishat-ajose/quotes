import 'package:flutter/material.dart';
import 'package:quotes/Database/db.dart';
import 'package:quotes/Screens/quote.dart';

class FavoriteQuotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorite Quotes'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: DBHelper().getEntries(),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            List<String> quotes =[];
          snapshot.data.forEach((e){
            quotes.add(e['quotes']);
          });
          return ListView.separated(
              separatorBuilder: (context, index) => Divider(color: Colors.white, thickness: 2,),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => snapshot.data.length == 0 ? Text("NO FAV", style: TextStyle(color: Colors.white, fontSize: 20)) :InkWell(
          
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuotePage(index, quotes, "Favorite", isFav: true,)));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data[index]['quotes'].split('-')[0], style: TextStyle(color: Colors.white, fontSize: 18)),
                      SizedBox(height: 10,),
                      Align(child: Text(snapshot.data[index]['quotes'].split('-')[1], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),), alignment: Alignment.bottomRight,)
                      ],
                    ),
                ),
              )
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}