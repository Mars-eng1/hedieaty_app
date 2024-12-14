import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart'; // <-- Import UserModel
import '../models/friend_model.dart'; // <-- Import FriendModel

class LocalDbService {
  static Database? _database;

  // Initialize Database
  static Future<void> init() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'hedieaty.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            email TEXT,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE friends (
            id TEXT PRIMARY KEY,
            name TEXT,
            profilePicUrl TEXT,
            upcomingEventsCount INTEGER
          )
        ''');
      },
    );
  }

  // Save User Info
  static Future<void> saveUser(UserModel user) async {
    await _database?.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Friends (from SQLite)
  static Future<List<Friend>> getFriends() async {
    final List<Map<String, dynamic>> maps = await _database?.query('friends') ?? [];
    return List.generate(maps.length, (i) {
      return Friend.fromMap(maps[i]);
    });
  }

  // Save Friend
  // Save Friend (to SQLite)
  static Future<void> saveFriend(Friend friend) async {
    await _database?.insert(
      'friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
