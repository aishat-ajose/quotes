import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String QUOTE = 'quotes';
  static const String TABLE = 'Favorite';
  static const String DB_NAME = 'favorite.db';
 
  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $QUOTE TEXT)");
  }
 
  Future<int> save(String quote) async {
    var dbClient = await db;
    var result = await dbClient.insert(TABLE,{
      'id': DateTime.now().millisecondsSinceEpoch,
      'quotes': quote
    });
    print("Added Favorite");
    return result;
  }


  Future<List<Map<String, dynamic>>> getEntries() async {
    Database database = await db;
    List<Map<String, dynamic>> result  = await database.query(TABLE, columns: [ID, QUOTE]);
    return(List.generate(result.length, (index){
      return(result[index]);
    }));

  }

  Future<List<Map>> isFavourite(String quote) async {
    Database database = await db;
    List<Map> result = await database.query(TABLE, where: 'quotes = ?', whereArgs: [quote]);
    return result;
  }

  Future<int> removeFavourite(String quote) async {
    Database database = await db;
    var result = await database.delete(TABLE, where: 'quotes = ?', whereArgs: [quote]);
    print('Removed Favorite');
    return result;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
