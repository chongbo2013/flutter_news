import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future<Database> initializeUserDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dogs.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE dogs (id INTEGER PRIMARY KEY, description TEXT, title TEXT, imageUrl TEXT, learnMark INTEGER default 0 )');
    });
    return database;
  }

   addAllNoticeToDB(List<Notice> noties) async {
    //Get database path
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dogs.db");

    //Try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: false);
      print("Create Account is Opening database");
    } catch (e) {
      print("Error $e");
    }
    var testIterator = noties.iterator;
    //Insert some records in a transaction;
    await db.transaction((txn) async {

      while (testIterator.moveNext()) {
        var img = testIterator.current.img;
        var title = testIterator.current.title;
        var description = testIterator.current.description;
        var learnMark = 0;
        txn.rawInsert(
            'INSERT INTO dogs(imageUrl, title,description,learnMark) VALUES("$img", "$title", "$description", "$learnMark")');
      }
    });

    //Close the database
    await db.close();
  }

  addNoticeToDB(Notice notice) async {
    //Get database path
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dogs.db");

    //Try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: false);
      print("Create Account is Opening database");
    } catch (e) {
      print("Error $e");
    }

    //Insert some records in a transaction;
    await db.transaction((txn) async {
      var img = notice.img;
      var title = notice.title;
      var description = notice.description;
      var learnMark = notice.learnMark;
      await txn.rawInsert(
          'INSERT INTO dogs(imageUrl, title,description,learnMark) VALUES("$img", "$title", "$description", "$learnMark")');
    });

    //Close the database
    await db.close();
  }
  queryAll(int page,int pageSize) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dogs.db");

    // try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: false);
      print("Login Opening database");
    } catch (e) {
      print("Error $e");
    }

    int pageOffset=page*pageSize;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM dogs Limit "$pageSize" Offset "$pageOffset"');



    // Close the database
    await db.close();

    return list;
  }
  querySearch(String query) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dogs.db");

    // try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: false);
      print("Login Opening database");
    } catch (e) {
      print("Error $e");
    }

    List args=List<String>();
    args.add("%"+query+"%");
    List<Map> list = await db.rawQuery(
        'SELECT * FROM dogs WHERE title like ? ',args);


    // Close the database
    await db.close();

    return list;
  }

  run(String query) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dogs.db");

    // try opening (will work if it exists)
    Database db;
    try {
      db = await openDatabase(path, readOnly: false);
      print("Login Opening database");
    } catch (e) {
      print("Error $e");
    }

    List<Map> list = await db.rawQuery(query);

    // Close the database
    await db.close();

    return list;
  }
}
