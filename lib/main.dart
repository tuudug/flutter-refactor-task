import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:get/get.dart';

import 'models/item.dart';

void main() async {
  Hive.registerAdapter(ItemAdapter()); 
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Refactor Task App',
      theme: _getLightTheme(),
      darkTheme: _getDarkTheme(),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
  ThemeData _getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Controller listController = Get.put(Controller());
  final RxList items = [].obs;
  final RxBool isGridView = false.obs;
  final Box myBox = Hive.box('myBox'); 

  @override
  Widget build(BuildContext context) {
    items.value = myBox.get("list") ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Refactor Task App')),
      body: Obx(() {
        if (isGridView.value) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title ?? ''),
                subtitle: Text(item.description ?? ''),
              );
            },
          );
        } else {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title ?? ''),
                subtitle: Text(item.description ?? ''),
              );
            },
          );
        }
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await listController.updateList();
              myBox.put("list", listController.items);
              items.value = listController.items;
            },
            tooltip: 'Fetch Data',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              isGridView.value = !isGridView.value;
            },
            tooltip: 'Toggle View',
            child: Icon(isGridView.value ? Icons.view_list : Icons.grid_on),
          ),
        ],
      ),
    );
  }
}

Future<List<Item>> fetchItemsFromAPI() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List responseData = json.decode(response.body);
      final List<Item> itemList = responseData.map((item) => Item.fromJson(item)).toList();
      return itemList;
    } else {
      throw Exception("API Error");
    }
  }

class Controller extends GetxController {
  List<Item> items = [];
  Future<void> updateList() async {
    items = await fetchItemsFromAPI();
    update();
  }
}
