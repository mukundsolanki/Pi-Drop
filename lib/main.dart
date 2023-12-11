import 'package:flutter/material.dart';
import 'bottom_sheet.dart';
import 'details_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File picker demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FilePickerDemo(title: 'File picker demo'),
    );
  }
}

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("File picker demo"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DetailsWidget(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomSheetWidget.show(context);
          },
          tooltip: 'Open Bottom Sheet',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
