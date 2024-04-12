import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  File? selectedImage;
  String? message = ""; 

  uploadImage() async {
    final request = http.MultipartRequest("POST", Uri.parse("https://72e3-2409-408c-2e9f-5fd5-1c52-23cc-1f5a-d4ff.ngrok-free.app/upload_image"));
    // Print request headers
    print(request.headers);

    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile('image', selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(), filename: selectedImage!.path.split("/").last)
    );
    request.headers.addAll(headers);
    
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    setState(() {
      message = resJson['message'];
    });
  }

  Future getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          selectedImage == null 
            ? const Text("Please selelct image to upload")
            : Image.file(selectedImage!),
          TextButton.icon(onPressed: uploadImage, icon: const Icon(Icons.upload_file) ,label: const Text("upload"))
        ],),
      ),
      floatingActionButton: FloatingActionButton(onPressed: getImage, child: Icon(Icons.add_a_photo),),
    );
  }
}