// lib/screens/add_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AddEntryScreen extends StatefulWidget {
  final Future<Database> database;
  final int userId;

  const AddEntryScreen({
    Key? key,
    required this.database,
    required this.userId,
  }) : super(key: key);

  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Happy';

  final List<String> _categories = [
    'Happy',
    'Sad',
    'Excited',
    'Anxious',
    'Grateful',
    'Angry',
  ];

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final db = await widget.database;
      await db.insert(
        'entries',
        {
          'userId': widget.userId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category': _selectedCategory,
          'date': DateTime.now().toIso8601String(),
        },
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Journal Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration:
                    const InputDecoration(labelText: 'How are you feeling?'),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
