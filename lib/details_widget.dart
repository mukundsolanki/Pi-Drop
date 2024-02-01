import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DetailsWidget extends StatefulWidget {
  @override
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  List<String> fileNames = [];

  @override
  void initState() {
    super.initState();
    fetchFileNames();
  }

  Future<void> fetchFileNames() async {
    try {
      // Todo: Making it dynamic 
      var url = Uri.parse('http://192.168.29.192:3000/files');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data is List && data.every((element) => element is String)) {
          setState(() {
            fileNames = List<String>.from(data);
          });
        } else {
          throw Exception('Invalid server response format');
        }
      } else {
        throw Exception(
            'Failed to fetch file names. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching file names: $e');
    }
  }

  Future<void> downloadFile(String fileName) async {
    try {
      var url = Uri.parse('http://192.168.29.192:3000/uploads/$fileName');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Get the app's external storage directory
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/$fileName';

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Snackbar provides an pop up from  bottom like a toast message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File saved successfully at: $filePath'),
        ));
      } else {
        throw Exception(
            'Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await fetchFileNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          itemCount: fileNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.file_download),
              title: Text(fileNames[index]),
              onTap: () => downloadFile(fileNames[index]),
            );
          },
        ),
      ),
    );
  }
}
