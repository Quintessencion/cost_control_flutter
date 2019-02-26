import 'dart:async';

import 'package:path/path.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/entities/month.dart';
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
          "cost REAL"
          ")");
      await db.execute("CREATE TABLE Month ("
          "id TEXT PRIMARY KEY,"
          "yearNumber INTEGER,"
          "number INTEGER,"
          "accumulationPercentage INTEGER"
          ")");
      await db.execute("CREATE TABLE MonthMovement ("
          "id TEXT PRIMARY KEY,"
          "direction INTEGER,"
          "monthId TEXT,"
          "name TEXT,"
          "sum REAL"
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
          case 0:
            desc = "Еда";
            break;
          case 1:
            desc = "Вода";
            break;
          case 2:
            desc = "Транспорт";
            break;
          case 3:
            desc = "Что-то";
            break;
        }
        await db.insert(
            "Expense",
            new Expense(
              id: (i * 30 + j).toString(),
              year: 2019,
              month: i,
              day: j,
              description: desc,
              cost: random.nextInt(1500).toDouble(),
            ).toJson());
      }
    }
  }

  Future<int> addExpense(Expense expense) async {
    final db = await database;
    return db.insert("Expense", expense.toJson());
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return db.update(
      "Expense",
      expense.toJson(),
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }

  Future<Expense> getExpense(int id) async {
    final db = await database;
    var res = await db.query("Expense", where: "id = ?", whereArgs: [id]);
    Completer completer = Completer();
    completer
        .complete(await res.isNotEmpty ? Expense.fromJson(res.first) : null);
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

  Future<int> addMonthMovement(MonthMovement movement) async {
    final db = await database;
    return db.insert("MonthMovement", movement.toJson());
  }

  Future<int> updateMonthMovement(MonthMovement movement) async {
    final db = await database;
    return db.update(
      "MonthMovement",
      movement.toJson(),
      where: "id = ?",
      whereArgs: [movement.id],
    );
  }

  Future<MonthMovement> getMonthMovement(String id) async {
    final db = await database;
    var res = await db.query("MonthMovement", where: "id = ?", whereArgs: [id]);
    Completer completer = Completer();
    completer.complete(
        await res.isNotEmpty ? MonthMovement.fromJson(res.first) : null);
    return completer.future;
  }

  Future<List<MonthMovement>> getMonthMovementsByMonthId(String monthId) async {
    final db = await database;
    var res = await db
        .query("MonthMovement", where: "monthId = ?", whereArgs: [monthId]);
    List<MonthMovement> list = res.isNotEmpty
        ? res.map((c) => MonthMovement.fromJson(c)).toList()
        : [];
    Completer completer = new Completer<List<MonthMovement>>();
    completer.complete(list);
    return completer.future;
  }

  Future<List<MonthMovement>> getAllMonthMovements() async {
    final db = await database;
    var res = await db.query("MonthMovement");
    List<MonthMovement> list = res.isNotEmpty
        ? res.map((c) => MonthMovement.fromJson(c)).toList()
        : [];
    Completer completer = new Completer<List<MonthMovement>>();
    completer.complete(list);
    return completer.future;
  }

  Future<int> deleteMonthMovement(String id) async {
    final db = await database;
    return db.delete("MonthMovement", where: "id = ?", whereArgs: [id]);
  }

  Future<int> addMonth(Month month) async {
    final db = await database;
    return db.insert("Month", month.toJson());
  }

  Future<int> updateMonth(Month month) async {
    final db = await database;
    return db.update(
      "Month",
      month.toJson(),
      where: "id = ?",
      whereArgs: [month.id],
    );
  }

  Future<Month> getMonth(String id) async {
    final db = await database;
    var res = await db.query("Month", where: "id = ?", whereArgs: [id]);

    Completer completer = Completer<Month>();
    if (res.isNotEmpty) {
      Month month = Month.fromJson(res.first);
      List<MonthMovement> movements =
          await getMonthMovementsByMonthId(month.id);
      for (MonthMovement movement in movements) {
        if (movement.direction > 0) {
          month.incomes.add(movement);
        } else {
          month.expenses.add(movement);
        }
      }
      completer.complete(month);
    } else {
      completer.complete(null);
    }

    return completer.future;
  }

  Future<List<Month>> getAllMonths() async {
    final db = await database;
    var res = await db.query("Month");
    List<Month> list =
        res.isNotEmpty ? res.map((c) => Month.fromJson(c)).toList() : [];
    Completer completer = new Completer<List<Month>>();
    completer.complete(list);
    return completer.future;
  }
}
