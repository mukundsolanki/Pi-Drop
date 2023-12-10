import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const FilePickerDemo({super.key, required this.title});

  final String title;

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("File picker demo"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selected file:',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10,),
                      ListView.separated(
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return Text(result?.files[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold));
                          }, separatorBuilder: (BuildContext context, int index) { 
                            return const SizedBox(height: 5,);
                           },)
                    ],
                  ),
                ),
                const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result =
                        await FilePicker.platform.pickFiles(allowMultiple: true);
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {});
                      for (var element in result!.files) {
                        print(element.name);
                      }
                    }
                  },
                  child: const Text("File Picker"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}