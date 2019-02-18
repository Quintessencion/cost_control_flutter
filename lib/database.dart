import 'dart:async';

import 'package:path/path.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "CostControl.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Expense ("
          "id TEXT PRIMARY KEY,"
          "year INTEGER,"
          "month INTEGER,"
          "day INTEGER,"
          "description TEXT,"
          "cost INTEGER"
          ")");
      generateTestData(db);
    });
  }

  void generateTestData(Database db) async {
    await db.insert(
        "Expense",
        new Expense(
          id: "1",
          year: 2019,
          month: 1,
          day: 1,
          description: "Еда",
          cost: 100,
        ).toJson());
    await db.insert(
        "Expense",
        new Expense(
          id: "2",
          year: 2019,
          month: 1,
          day: 2,
          description: "Не помню на что",
          cost: 4000,
        ).toJson());
    await db.insert(
        "Expense",
        new Expense(
          id: "3",
          year: 2019,
          month: 1,
          day: 3,
          description: "Маршрутка",
          cost: 16,
        ).toJson());
    await db.insert(
        "Expense",
        new Expense(
          id: "4",
          year: 2019,
          month: 1,
          day: 3,
          description: "Еда",
          cost: 100,
        ).toJson());
  }

  void generateBigData(Database db) async {
    Random random = new Random();
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 28; j++) {
        String desc;
        switch (random.nextInt(4)) {
          case 0: desc = "Еда"; break;
          case 1: desc = "Вода"; break;
          case 2: desc = "Транспорт"; break;
          case 3: desc = "Что-то"; break;
        }
        await db.insert(
            "Expense",
            new Expense(
              id: (i * 30 + j).toString(),
              year: 2019,
              month: i,
              day: j,
              description: desc,
              cost: random.nextInt(1500),
            ).toJson());
      }
    }
  }

  Future<int> addExpense(Expense expense) async {
    final db = await database;
    return db.insert("Expense", expense.toJson());
  }

  Future<int> updateClient(Expense expense) async {
    final db = await database;
    return db.update(
      "Client",
      expense.toJson(),
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }

  Future<Expense> getExpense(int id) async {
    final db = await database;
    var res = await db.query("Expense", where: "id = ?", whereArgs: [id]);
    Completer completer = Completer();
    completer.complete(await res.isNotEmpty ? Expense.fromJson(res.first) : null);
    return completer.future;
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    var res = await db.query("Expense");
    List<Expense> list =
        res.isNotEmpty ? res.map((c) => Expense.fromJson(c)).toList() : [];
    Completer completer = new Completer<List<Expense>>();
    completer.complete(list);
    return completer.future;
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete("Expense", where: "id = ?", whereArgs: [id]);
  }
}
