import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class AP {
  final String iata, icao, name, location;

  AP({
    required this.iata,
    required this.icao,
    required this.name,
    required this.location,
  });

  factory AP.fromMap(Map<String, dynamic> json) => AP(
      iata: json['iata'],
      icao: json['icao'],
      name: json['name'],
      location: json['location']);

  Map<String, dynamic> toMap() {
    return {
      'iata': iata,
      'icao': icao,
      'name': name,
      'location': location,
    };
  }
}

class DatabaseHelper {
  //DatabaseHelper._privateConstructor();
  //static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'codes_table.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ap_codes(
          iata TEXT,
          icao TEXT,
          name TEXT,
          location TEXT
      );
      
      ''');
    insertData();
  }

  Future<List<AP>> getApcode(String lookBy, String search) async {
    Database db = await database;
    var codes = await db
        .rawQuery("select* FROM ap_codes WHERE $lookBy like '%$search%'");

    List<AP> codesList =
        codes.isNotEmpty ? codes.map((c) => AP.fromMap(c)).toList() : [];
    return codesList;
  }

  Future<int> add(AP ap) async {
    Database db = await database;
    return await db.insert('ap_codes', ap.toMap());
  }

  Future<int> update(AP ap) async {
    Database db = await database;
    return await db.update('ap_codes', ap.toMap(),
        where: "iata = ?", whereArgs: [ap.iata]);
  }

  void insertData() async {
    String res;
    List<String> letters = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];

    String letter;
    int s = 0;
    for (int i = 0; i < letters.length; i++) {
      letter = letters[i];
      res = await rootBundle.loadString('assets/$letter.txt');
      List<String> resarray = res.split("\n");
      for (int i = 0; i < resarray.length; i++) {
        List<String> data = resarray[i].split("*");
        try {
          add(
            AP(
              iata: data[0],
              icao: data[1],
              name: data[2],
              location: data[3],
            ),
          );
          s = s + 1;
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }
}
