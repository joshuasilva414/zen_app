import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  DatabaseInstance._privateConstructor();
  static final DatabaseInstance instance = DatabaseInstance._privateConstructor();

  static Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'zen.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE entries(id INTEGER PRIMARY KEY, timestamp TEXT, content TEXT)');
        await db.execute(
            'CREATE TABLE days(id INTEGER PRIMARY KEY, timestamp TEXT, content TEXT)');
        await db.execute(
            'CREATE TABLE prompts(id INTEGER PRIMARY KEY, timestamp TEXT, content TEXT)');
      },
    );
  }
}
