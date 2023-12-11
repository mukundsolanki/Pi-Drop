import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;


class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetWidget();
      },
    );
  }
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  FilePickerResult? result;
  bool isReadyToUpload = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result == null) {
                  print("No file selected");
                } else {
                  setState(() {
                    isReadyToUpload = true;
                  });
                  for (var element in result!.files) {
                    print(element.name);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: isReadyToUpload ? Colors.green : Colors.blue,
                  ),
                  color: isReadyToUpload ? Colors.green : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    isReadyToUpload ? Icons.check : Icons.add,
                    size: 40.0,
                    color: isReadyToUpload ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isReadyToUpload
                  ? '${result?.files.length} Files Ready to upload'
                  : 'Select your files',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (isReadyToUpload)
              ElevatedButton(
                onPressed: () {
                  if (result != null) {
                    _uploadFile(result!.files);
                    Navigator.pop(context);
                  } else {
                    print("Please pick a file first");
                  }
                },
                child: const Text("Upload"),
              ),
          ],
        ),
      ),
    );
  }
}

void _uploadFile(List<PlatformFile> files) async {
  try {
    for (var file in files) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.29.192:3000/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path!,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error uploading file: $e');
  }
}
