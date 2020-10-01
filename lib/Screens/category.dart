import 'package:flutter/material.dart';
import 'package:quotes/Screens/quote.dart';

class CategoryPage extends StatelessWidget {
  final Map category;
  CategoryPage(this.category);
  
  @override
  Widget build(BuildContext context) {

    List<String> quotes = category['quotes'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(category['name'] + ' Quotes'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(color: Colors.white, thickness: 2,),
          itemCount: quotes.length,
          itemBuilder: (context, index) => buildQuotes(context, index)
        ),
      ),
    );
  }

  Widget buildQuotes(context, int index ){
    List<String> quotes = category['quotes'];
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> QuotePage(index, quotes, category['name'],)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quotes[index].split('-')[0], style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10,),
            Align(child: Text(quotes[index].split('-')[1], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),), alignment: Alignment.bottomRight,)
          ],
        ),
      ),
    );
  }
}