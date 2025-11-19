import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("app.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Upgrade untuk versi 2: tambah kolom isLoggedIn dan photoPath
          await db.execute('ALTER TABLE users ADD COLUMN isLoggedIn INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE users ADD COLUMN photoPath TEXT');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT UNIQUE,
      password TEXT,
      isLoggedIn INTEGER DEFAULT 0,
      photoPath TEXT
    )
  ''';

    await db.execute(userTable);
  }

  /// REGISTER USER
  Future<int> register(String name, String email, String password,
      {String? photoPath}) async {
    final db = await instance.database;

    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'isLoggedIn': 0,
        'photoPath': photoPath
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// LOGIN CHECK
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// GET LOGGED IN USER
  Future<Map<String, dynamic>?> getLoggedUser() async {
    final db = await database;
    final result = await db.query("users", where: "isLoggedIn = 1");

    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// LOGOUT USER
  Future<void> logoutUser() async {
    final db = await database;
    await db.update("users", {"isLoggedIn": 0}, where: "isLoggedIn = 1");
  }

  /// SET USER LOGGED IN
  Future<void> setUserLoggedIn(int id) async {
    final db = await database;

    // Set semua user jadi logout
    await db.update("users", {"isLoggedIn": 0});

    // Set user ini jadi login
    await db.update("users", {"isLoggedIn": 1}, where: "id = ?", whereArgs: [id]);
  }

  /// UPDATE USER (nama, email, photoPath)
  Future<void> updateUser(int id, String name, String email,
      {String? photoPath}) async {
    final db = await database;
    await db.update(
      'users',
      {
        'name': name,
        'email': email,
        'photoPath': photoPath, // bisa null jika tidak diubah
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
