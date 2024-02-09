import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';




class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  int _sumIntegers() {
    final Box box = Hive.box('data');
    int sum = 0;

    for (int i = 0; i < box.length; i++) {
      final data = box.getAt(i) as Map<String, dynamic>;
      sum += data['int'] as int;
    }

    return sum;
  }

  void _updateListTile(BuildContext context, int index) {
    final Box box = Hive.box('data');
    final data = box.getAt(index) as Map<String, dynamic>;
    final TextEditingController stringController =
    TextEditingController(text: data['string']);
    final TextEditingController intController =
    TextEditingController(text: data['int'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Update List Tile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter new values:'),
            TextField(
              controller: stringController,
              decoration: InputDecoration(labelText: 'String'),
            ),
            TextField(
              controller: intController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Integer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final String newString = stringController.text;
              final int newInt = int.parse(intController.text);

              final Map<String, dynamic> newData = {
                'string': newString,
                'int': newInt,
                'date': data['date'],
              };

              box.putAt(index, newData);

              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
          TextButton(
            onPressed: () {
              box.deleteAt(index); // Delete the item from the box
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _calculateSum() {
    final int sum = _sumIntegers();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sum of Integers'),
        content: Text('The sum of all integers is: $sum'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('data');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Display Page'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'روز'),
              Tab(text: 'هفته'),
              Tab(text: 'ماه'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final data = box.getAt(index) as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['string']),
                  subtitle: Text('Date: ${data['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Integer: ${data['int']}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          box.deleteAt(index); // Delete the item from the box
                          setState(() {}); // Update the UI after deletion
                        },
                      ),
                    ],
                  ),
                  onTap: () => _updateListTile(context, index),
                );
              },
            ),
            ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final data = box.getAt(index) as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['string']),
                  subtitle: Text('Week: ${data['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Integer: ${data['int']}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          box.deleteAt(index); // Delete the item from the box
                          setState(() {}); // Update the UI after deletion
                        },
                      ),
                    ],
                  ),
                  onTap: () => _updateListTile(context, index),
                );
              },
            ),
            ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final data = box.getAt(index) as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['string']),
                  subtitle: Text('Month: ${data['date']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Integer: ${data['int']}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          box.deleteAt(index); // Delete the item from the box
                          setState(() {}); // Update the UI after deletion
                        },
                      ),
                    ],
                  ),
                  onTap: () => _updateListTile(context, index),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _calculateSum,
            child: Text("مجموع")
        ),
      ),
    );
  }
}