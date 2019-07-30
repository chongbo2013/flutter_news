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
          'CREATE TABLE dogs (id INTEGER PRIMARY KEY, description TEXT, title TEXT, img TEXT, learnMark INTEGER)');
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
        var learnMark = testIterator.current.learnMark;
        txn.rawInsert(
            'INSERT INTO dogs(img, title,description,learnMark) VALUES("$img", "$title", "$description", "$learnMark")');
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
          'INSERT INTO dogs(img, title,description,learnMark) VALUES("$img", "$title", "$description", "$learnMark")');
    });

    //Close the database
    await db.close();
  }
  queryAll() async {
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

    List<Map> list = await db.query('dogs', columns: [
      'id',
      'img',
      'title',
      'description',
      'learnMark'
    ]);


    // Close the database
    await db.close();

    return list;
  }
  authLogin(String inputUsername, String inputPassword) async {
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

    List<Map> list = await db.rawQuery(
        'SELECT * FROM dogs WHERE username = "$inputUsername" AND password = "$inputPassword"');


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
