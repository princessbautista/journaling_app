

// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  final Future<Database> database;
  final int userId;

  const HomeScreen({
    Key? key,
    required this.database,
    required this.userId,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Map<String, dynamic>>> _getEntries() async {
    final db = await widget.database;
    return db.query(
      'entries',
      where: 'userId = ?',
      whereArgs: [widget.userId],
      orderBy: 'date DESC',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntryScreen(
                    database: widget.database,
                    userId: widget.userId,
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final entry = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(entry['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry['description']),
                        Text(
                          'Feeling: ${entry['category']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(entry['date']),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
