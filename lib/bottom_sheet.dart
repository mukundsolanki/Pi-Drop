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
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: result?.files.length ?? 0,
                    itemBuilder: (context, index) {
                      return Text(result?.files[index].name ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                  )
                ],
              ),
            ),
          // const Spacer(),
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
          const SizedBox(height: 20), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              if (result != null) {
                _uploadFile(result!.files);
              } else {
                print("Please pick a file first");
              }
            },
            child: const Text("Upload"),
          ),
        ],
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
