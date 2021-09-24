import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ha_firestore_scaffold/ha_firestore_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAFirestore Scaffold',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'HAFirestore Scaffold'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HAFirestoreScaffold(
      title: widget.title,
      query: FirebaseFirestore.instance
          .collection("users")
          .orderBy("addedDate", descending: true),
      limit: (deviceType) {
        return 50;
      },
      groupBy: "addedDate",
      header: (groupFieldValue) {
        return Container(
          color: Colors.white,
          child: Text("$groupFieldValue"),
        );
      },
      itembuilder: (context, snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['name'] ?? "no name"),
        );
      },
      emptyWidget: const Center(
        child: Text("no data found"),
      ),
      searchDelegate: HAFirestoreSearch(
        firestoreQuery: FirebaseFirestore.instance
            .collection("users")
            .orderBy("addedDate", descending: true),
        searchField: 'keywords',
        builder: (context, snapshot) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(data['name'] ?? "no name"),
          );
        },
        emptyWidget: const Center(
          child: Text("no search data found"),
        ),
      ),
    );
  }
}
