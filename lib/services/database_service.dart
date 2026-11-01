import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/intervention.dart';

class DatabaseService {
  DatabaseService._(); static final instance=DatabaseService._(); Database? _db;
  Future<Database> get db async { if(_db!=null)return _db!; final d=await getApplicationDocumentsDirectory(); _db=await openDatabase(p.join(d.path,'co_track_dz.db'),version:2,onCreate:(db,v)async{
    await db.execute('CREATE TABLE interventions(id INTEGER PRIMARY KEY AUTOINCREMENT,pdl TEXT NOT NULL UNIQUE,detector1 TEXT NOT NULL UNIQUE,detector2 TEXT NOT NULL UNIQUE,latitude REAL NOT NULL,longitude REAL NOT NULL,enterprise TEXT NOT NULL,bill_photo TEXT,detector1_photo TEXT,detector2_photo TEXT,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE enterprises(id INTEGER PRIMARY KEY AUTOINCREMENT,display_name TEXT NOT NULL,username TEXT NOT NULL UNIQUE,salt TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TEXT NOT NULL)');
  },onUpgrade:(db,old,v)async{ if(old<2){await db.execute('CREATE TABLE IF NOT EXISTS enterprises(id INTEGER PRIMARY KEY AUTOINCREMENT,display_name TEXT NOT NULL,username TEXT NOT NULL UNIQUE,salt TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TEXT NOT NULL)');} }); return _db!; }
  Future<String> register(String name,String username,String salt,String hash) async {final d=await db; await d.insert('enterprises',{'display_name':name,'username':username,'salt':salt,'password_hash':hash,'created_at':DateTime.now().toIso8601String()}); return username;}
  Future<Map<String,Object?>?> account(String username) async {final d=await db; final r=await d.query('enterprises',where:'username=?',whereArgs:[username],limit:1);return r.isEmpty?null:r.first;}
  Future<void> add(Intervention i) async {final d=await db;await d.insert('interventions',i.toMap(),conflictAlgorithm:ConflictAlgorithm.abort);}
  Future<List<Intervention>> all(String enterprise) async {final d=await db;final r=await d.query('interventions',where:'enterprise=?',whereArgs:[enterprise],orderBy:'created_at DESC');return r.map(Intervention.fromMap).toList();}
  Future<int> todayCount(String enterprise) async {final d=await db;final day=DateTime.now().toIso8601String().substring(0,10);return Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM interventions WHERE enterprise=? AND created_at LIKE ?', [enterprise,'$day%']))??0;}
}
