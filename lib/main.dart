import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // Handle file not selected
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.29.80:5500/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _selectedFile!.path,
    ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // File uploaded successfully
        print('File uploaded!');
      } else {
        // Handle error
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick a file'),
            ),
            SizedBox(height: 20),
            if (_selectedFile != null)
              Text('Selected File: ${_selectedFile!.path}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
