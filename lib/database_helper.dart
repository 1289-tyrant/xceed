import 'dart:async';
import 'dart:io' as io;

import './sqluser_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    // First `id` for making data in db unique, second `_id` for id returned fron json
    //create course table
    await db.execute(""" 
    CREATE TABLE user(
      user_id INTEGER PRIMARY KEY,
      email TEXT,
      password TEXT
    )""");
    print("Created user tables");
  }

  //HANDLING STUDENT RELATED ACTIVITIES
  Future<int> saveUser(SqlUser user) async {
    var dbClient = await db;
    int res = await dbClient.insert("student", user.toMap());
    return res;
  }

  Future<SqlUser> loginUser(String email, String password) async {
    var dbClient = await db;
    String sql =
        "SELECT * FROM user WHERE email = $email AND password = $password";
    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    return SqlUser.fromMap(result.first);
  }
}