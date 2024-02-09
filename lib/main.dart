import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('data');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => InputPage(),
        '/display': (context) => DisplayPage(),
      },
    );
  }
}

class InputPage extends StatelessWidget {
  String text = "اشتراک گذاری برنامه";
  final TextEditingController stringController = TextEditingController();
  final TextEditingController intController = TextEditingController();

  void _saveData(BuildContext context) {
    final String stringValue = stringController.text;
    final int intValue = int.parse(intController.text);

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final Map<String, dynamic> data = {
      'string': stringValue,
      'int': intValue,
      'date': formattedDate,
    };

    final Box box = Hive.box('data');
    box.add(data);

    stringController.clear();
    intController.clear();

    Navigator.pushNamed(context, '/display');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('حساب روزانه')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: stringController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))),
                  hintText: 'نوت'),
            ),
            // SizedBox(height: 5,),

            TextField(
              controller: intController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5))),
                hintText: 'قیمت',




              ),
            ),
            SizedBox(height: 10,),
            MaterialButton(
              height: 44,

              color: Colors.blueAccent,
              onPressed: () {
                _saveData(context);
              },
              child: Text('ذخیره',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}