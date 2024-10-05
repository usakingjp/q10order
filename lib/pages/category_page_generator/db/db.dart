import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

enum DataBaseName {
  categories,
  categoryItems;

  String get name {
    switch (this) {
      case categories:
        return 'categories';
      case categoryItems:
        return 'category_items';
    }
  }
}

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
  // print(join(path.path, 'category.db'));
  return await openDatabase(
    join(path.path, 'category.db'),
    // 'category.db',
    // inMemoryDatabasePath,
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE if not exists categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, parentId INTEGER NULLABLE)",
      );
      await db.execute(
        "CREATE TABLE if not exists category_items (itemCode TEXT PRIMARY KEY,sellerCode TEXT, brandName TEXT NULLABLE, itemTitle TEXT, categoryId1 INTEGER NULLABLE, categoryId2 INTEGER NULLABLE, categoryId3 INTEGER NULLABLE, categoryId4 INTEGER NULLABLE, categoryId5 INTEGER NULLABLE, categoryId6 INTEGER NULLABLE)",
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

Future<List<Map<String, dynamic>>> insertData(
    DataBaseName name, Map<String, dynamic> map) async {
  final Database db = await database();
  try {
    await db.insert(
      name.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    final List<Map<String, dynamic>> result = await getData(name);
    return result;
  } catch (e) {
    print(e);
    return [];
  } finally {
    await db.close();
  }
}

Future<List<Map<String, dynamic>>> insertOrReplaceData(
    DataBaseName name, Map<String, dynamic> map) async {
  final Database db = await database();
  try {
    await db.insert(
      name.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final List<Map<String, dynamic>> result = await getData(name);
    return result;
  } catch (e) {
    print(e);
    return [];
  } finally {
    await db.close();
  }
}

Future<List<Map<String, dynamic>>> getData(DataBaseName name) async {
  final Database db = await database();
  try {
    final List<Map<String, dynamic>> result = await db.query(
      name.name,
    );
    return result;
  } catch (e) {
    print(e);
    return [];
  } finally {
    await db.close();
  }
}
