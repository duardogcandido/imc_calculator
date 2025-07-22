import 'package:sqflite/sqflite.dart';

class Imc {
  int? id;
  double peso;
  double altura;

  Imc({this.id, required this.peso, required this.altura});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'Id': id,
      'Peso': peso,
      'Altura': altura,
    };
    return map;
  }

  factory Imc.fromMap(Map<dynamic, dynamic> map) {
    return Imc(
      id: map['Id'],
      peso: double.parse(map['Peso'].toString()),
      altura: double.parse(map['Altura'].toString()),
    );
  }
}

class ImcProvider {
  final String tableName = 'IMC';
  final String columnId = 'Id';
  final String columnAltura = 'Altura';
  final String columnPeso = 'Peso';
  final String pathDb = 'imc.db';

  Future open() async {
    var db = await openDatabase(pathDb, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableName ( 
  $columnId integer primary key autoincrement, 
  $columnAltura numeric not null,
  $columnPeso numeric not null)
''');
        });
  }

  Future<Imc> insert(Imc imc) async {
    var db = await openDatabase(pathDb);
    imc.id = await db.insert(tableName, imc.toMap());
    return imc;
  }

  Future<List<Imc>> getImcs() async {
    var db = await openDatabase(pathDb);
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnPeso, columnAltura]);

    List<Imc> resultList = [];

    for(var item in maps){
      resultList.add(Imc.fromMap(item));
    }

    return resultList;
  }

  Future<Imc> getImc(int id) async {
    var db = await openDatabase(pathDb);
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnPeso, columnAltura],
        where: '$columnId = ?',
        whereArgs: [id]);

      return Imc.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    var db = await openDatabase(pathDb);
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Imc todo) async {
    var db = await openDatabase(pathDb);
    return await db.update(tableName, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async {
    var db = await openDatabase(pathDb);
    db.close();
  }
}