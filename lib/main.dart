import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refactor Task App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Refactor Task App')),
      body: StreamBuilder<List<Item>>(
        stream: dataModel.itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item.title ?? ''),
                  subtitle: Text(item.description ?? ''),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: dataModel.fetchAndStoreItems,
        tooltip: 'Fetch Data',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DataModel extends ChangeNotifier {
  final _itemsController = StreamController<List<Item>>.broadcast();
  Database? _database;

  Stream<List<Item>> get itemsStream => _itemsController.stream;

  DataModel() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/sample_app.db';

    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY,
          title TEXT,
          description TEXT
        )
      ''');
    });

    _fetchItemsFromDatabase();
  }

  Future<void> _fetchItemsFromDatabase() async {
    final items = await _database?.query('items') ?? [];
    final itemList = items.map((item) => Item.fromJson(item)).toList();
    _itemsController.add(itemList);
  }

  Future<void> fetchAndStoreItems() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      final itemList = data.map((item) => Item.fromJson(item)).toList();
      Batch batch = _database!.batch();
      itemList.forEach((item) {
        batch.insert('items', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      });

      await batch.commit(noResult: true);
      _itemsController.add(itemList);
    } else {
      _itemsController.addError('Failed to fetch data from API');
    }
  }

  @override
  void dispose() {
    _itemsController.close();
    super.dispose();
  }
}

class Item {
  final int id;
  final String? title;
  final String? description;

  Item({required this.id, this.title, this.description});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      description: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
