import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q10order/models/item_name.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const String tableName = 'itemnames';

Future<Database> database() async {
  databaseFactoryOrNull = databaseFactoryFfi;
  sqfliteFfiInit();
  var path = await getApplicationSupportDirectory();
  // const scripts = {
  //   '3': [
  //     'ALTER TABLE configs ADD COLUMN ribraryImage INTEGER;',
  //     'ALTER TABLE configs ADD COLUMN itemcsvName INTEGER;',
  //   ],
  // };
  return await openDatabase(
    join(path.path, 'q10order_sys.db'),
    // inMemoryDatabasePath,
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE if not exists itemnames(q10cord TEXT PRIMARY KEY, shopCord TEXT, displayName TEXT)",
      );
    },
    // onUpgrade: (Database db, int oldVersion, int newVersion) async {
    //   debugPrint(oldVersion.toString());
    //   debugPrint(newVersion.toString());
    //   for (var i = oldVersion + 1; i <= newVersion; i++) {
    //     var queries = scripts[i.toString()];
    //     for (String query in queries!) {
    //       try {
    //         await db.execute(query);
    //       } catch (e) {
    //         debugPrint(e.toString());
    //       }
    //     }
    //   }
    // },
    version: 1,
  );
}

Future<bool> exist(ItemName model) async {
  final Database db = await database();
  List<Map> maps = await db
      .query(tableName, where: 'q10cord = ?', whereArgs: [model.q10cord]);
  if (maps.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

Future<List<ItemName>> exists(List<ItemName> models) async {
  final Database db = await database();
  List<String> cords = [
    for (var i = 0; i < models.length; i++) models[i].q10cord
  ];
  List<Map> maps = [];
  for (var cord in cords) {
    var get =
        await db.query(tableName, where: 'q10cord = ?', whereArgs: [cord]);
    if (get.isNotEmpty) {
      maps.add(get.first);
    }
  }
  // await db.query(tableName, where: 'q10cord = ?', whereArgs: cords);
  return List.generate(maps.length, (i) {
    return ItemName(
      q10cord: maps[i]['q10cord'],
      shopCord: maps[i]['shopCord'],
      displayName: maps[i]['displayName'],
    );
  });
}

Future<void> insert(ItemName model) async {
  final Database db = await database();
  try {
    await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> insertAll(List<ItemName> models,
    {List<String>? updates, List<String>? skips}) async {
  try {
    for (var model in models) {
      try {
        if (skips != null) {
          if (skips.contains(model.q10cord)) {
            continue;
          }
        }
        if (updates != null) {
          if (updates.contains(model.q10cord)) {
            await update(model);
          } else {
            await insert(model);
          }
        }
        await insert(model);
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<List<ItemName>> getAll() async {
  final Database db = await database();
  final List<Map<String, dynamic>> maps = await db.query(tableName);
  return List.generate(maps.length, (i) {
    return ItemName(
      q10cord: maps[i]['q10cord'],
      shopCord: maps[i]['shopCord'],
      displayName: maps[i]['displayName'],
    );
  });
}

Future<void> update(ItemName model) async {
  // Get a reference to the database.
  final db = await database();
  try {
    await db.update(
      tableName,
      model.toMap(),
      where: "q10cord = ?",
      whereArgs: [model.q10cord],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<void> delete(ItemName model) async {
  try {
    final db = await database();
    await db.delete(
      tableName,
      where: "q10cord = ?",
      whereArgs: [model.q10cord],
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}
