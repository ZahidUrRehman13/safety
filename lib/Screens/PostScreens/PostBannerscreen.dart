import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rabbit/TabScreen.dart';

class PostBanner extends StatefulWidget {
  const PostBanner({super.key});

  @override
  State<PostBanner> createState() => _PostBannerState();
}

class _PostBannerState extends State<PostBanner> {
  TextEditingController colorController = TextEditingController();
  TextEditingController buttonTextController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController textValueController = TextEditingController();
  String imageDownloadUrl = "";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFd2dfff),
              Color(0xFFced2ff),
              Color(0xFFcdcfff),
              Color(0xFFc3caff),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(left: 8.0,right: 8.0,top:height*0.05 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        color: Colors.black12,
                        width: double.infinity,
                        child: Center(
                            child: Icon(
                          Icons.image,
                          size: 30,
                        )),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: colorController,
                  decoration: InputDecoration(hintText: "0xFFFFFFFF"),
                ),
                TextField(
                  controller: buttonTextController,
                  decoration: InputDecoration(hintText: "button_text"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: "description"),
                ),
                TextField(
                  controller: newController,
                  decoration: InputDecoration(hintText: "new"),
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "title"),
                ),
                TextField(
                  controller: textValueController,
                  decoration: InputDecoration(hintText: "Show text instead of image"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                      color: const Color(0xFFDAA520),
                      onPressed: () {
                        uploadData();
                      },
                      child: Text("Upload")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      debugPrint("image_name_here ${result.files.first.name}");
      uploadImage(result.files.single.path!, result.files.first.name);
    }
  }

  Future<void> uploadImage(String imagePath, String fileName) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
    final UploadTask uploadTask = storageReference.putFile(File(imagePath));
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    imageDownloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    debugPrint("image_url_download $imageDownloadUrl");
  }

  Future<void> uploadData() async {
    final CollectionReference collection = FirebaseFirestore.instance.collection('data');

    await collection.add({
      'aligment': "horizontal",
      'button_text': buttonTextController.text.toString(),
      'color': colorController.text.isNotEmpty ? colorController.text : "0xFFFFFFFF",
      'description': descriptionController.text.toString(),
      'new': newController.text.toString(),
      'sources': "",
      'text': textValueController.text.isNotEmpty ? "true" : "false",
      'text_value': textValueController.text.isNotEmpty ? textValueController.text : "",
      'thumb': imageDownloadUrl,
      'title': titleController.text.toString(),
      'video': "false",
      'timestamp': FieldValue.serverTimestamp(),
    });
    debugPrint("data_uploaded_successfully");
    getAllTokens();
  }

  Future<void> getAllTokens() async {
    List<dynamic> tokens = [];
    var docSnapshot = await FirebaseFirestore.instance.collection('notificationTokens').get();
    for (var value in docSnapshot.docs) {
      tokens.add(jsonEncode(value.get('token')));
    }
    debugPrint("all_token $tokens");
    postData(tokens);
  }

  Future<void> postData(List<dynamic> tokens) async {
    const url = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA7rwg7qw:APA91bGKADixC9WBJI6NjKjXxbwEhScWTPONBP0K0WrT2Vv04_WTSFKwXc0xUlUkEbuOWrp6DrPVCv5dTRxt3ZugKfV0iTjWAq6Pek6rsYXrmJFk0o0oOnIFSQ8rXKJEmmDOKVt3nEAG'
    };
    final rawRequestBody = """{ "registration_ids" : $tokens,
        "notification": {
               "body": "${descriptionController.text}",
               "title": "-${textValueController.text}-",
               "priority": "high"
    },
    "data": {
    "slug": "New ",
    "body": "Watch Safety Awareness",
    "title": "Excellency of People",
    "content_available": true,
    "registration_ids": "null",
    "priority": "high"
    }
    }""";

    debugPrint("All_json_data  $rawRequestBody");

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: rawRequestBody,
    );
    if (response.statusCode == 200) {
      debugPrint('POST request successful');
      debugPrint('Response: ${response.body}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabScreen()));
    } else {
      debugPrint('POST request failed');
      debugPrint('Response: ${response.body}');
    }
  }
}
