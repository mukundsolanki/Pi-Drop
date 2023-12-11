import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchFileNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No files available.');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Files on Server:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

Future<List<String>> fetchFileNames() async {
  try {
    var url = Uri.parse('http://192.168.29.192:3000/files');
    
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> data = json.decode(response.body);
      
      if (data is List && data.every((element) => element is String)) {
        return List<String>.from(data);
      } else {
        throw Exception('Invalid server response format');
      }
    } else {
      throw Exception('Failed to fetch file names. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching file names: $e');
  }
}
}