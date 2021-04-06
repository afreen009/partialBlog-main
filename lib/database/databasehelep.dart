import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db_model.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "posts.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE posts ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "date TEXT"
          ")");
    });
  }

  addPersonToDatabase(DbModel person) async {
    final db = await database;
    var raw = await db.insert(
      "posts",
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updatePerson(DbModel person) async {
    final db = await database;
    var response = await db.update("posts", person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
    return response;
  }

  Future<DbModel> getPersonWithId(int id) async {
    final db = await database;
    var response = await db.query("posts", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? DbModel.fromMap(response.first) : null;
  }

  Future<List<DbModel>> getAllPersons() async {
    final db = await database;
    var response = await db.query("posts");
    List<DbModel> list = response.map((c) => DbModel.fromMap(c)).toList();
    return list;
  }

  deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("posts", where: "id = ?", whereArgs: [id]);
  }

  deleteAllPersons() async {
    final db = await database;
    db.delete("posts");
  }
}
