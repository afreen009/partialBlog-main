import 'dart:async';
import 'dart:io';

import 'package:google_signin_example/database/report.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Database databasecheck;
Database reportdatabasecheck;

/* A class with all the functions dealing with sqlite*/
class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

//#report file
  Future<Database> get reportDatabase async {
    if (reportdatabasecheck != null) return reportdatabasecheck;
    reportdatabasecheck = await getReportDatabaseInstance();
    return reportdatabasecheck;
  }

  Future<Database> getReportDatabaseInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    /*To make sepearte db path for different users like for example :  medicineXYZ.db for mail:XYZ@gmail.com*/
    String reportdatabasename =
        "report" + email.substring(0, email.indexOf('@')) + ".db";
    //reportdatabasename);
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, reportdatabasename);
    //path);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE reportdata ("
          "description primary key TEXT,"
          ")");
    });
  }

  addReportToDatabase(Report report) async {
    final db = await reportDatabase;
    var raw = await db.insert(
      "reportdata",
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<Report>> getAllReports() async {
    final db = await reportDatabase;
    var response = await db.query("reportdata");
    List<Report> list = response.map((c) => Report.fromMap(c)).toList();
    //list[1].description);
    //"new");
    return list;
  }

  Future<Database> get database async {
    if (databasecheck != null) return databasecheck;
    databasecheck = await getDatabaseInstance();
    return databasecheck;
  }

  Future<Database> getDatabaseInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    /*To make sepearte db path for different users like for example :  medicineXYZ.db for mail:XYZ@gmail.com*/
    String databasename =
        "posts" + email.substring(0, email.indexOf('@')) + ".db";
    //databasename);
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databasename);
    //path);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE medicinedata ("
          "ids integer primary key AUTOINCREMENT,"
          "dosage TEXT,"
          "start TEXT,"
          "interval integer,"
          "name TEXT"
          ")");
    });
  }

  // addMedicineToDatabase(Medicine medicine) async {
  //   final db = await database;
  //   var raw = await db.insert(
  //     "medicinedata",
  //     medicine.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return raw;
  // }

  // /*updateMedicine(Medicine medicine) async {
  //   final db = await database;
  //   var response = await db.update("medicinedata", medicine.toMap(),
  //       where: "ids = ?", whereArgs: [medicine.ids]);
  //   return response;
  // }*/

  // Future<Medicine> getMedicineWithId(int id) async {
  //   final db = await database;
  //   var response =
  //       await db.query("medicinedata", where: "ids = ?", whereArgs: [id]);
  //   return response.isNotEmpty ? Medicine.fromMap(response.first) : null;
  // }

  // Future<List<Medicine>> getAllMedicines() async {
  //   final db = await database;
  //   var response = await db.query("medicinedata");
  //   List<Medicine> list = response.map((c) => Medicine.fromMap(c)).toList();
  //   return list;
  // }

  deleteMedicineWithId(int id) async {
    final db = await database;
    return db.delete("medicinedata", where: "ids = ?", whereArgs: [id]);
  }

  deleteAllMedicines() async {
    final db = await database;
    db.delete("medicinedata");
  }
}
