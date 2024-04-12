import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart'; // Dependency for recording audio
import "package:http/http.dart" as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();

  File? selectedAudio;
  String? message = "";

  uploadAudio() async {
    final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://72e3-2409-408c-2e9f-5fd5-1c52-23cc-1f5a-d4ff.ngrok-free.app/upload_audio"));
    print(request.headers);

    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'audio',
        selectedAudio!.readAsBytes().asStream(),
        selectedAudio!.lengthSync(),
        filename: selectedAudio!.path.split("/").last));
    request.headers.addAll(headers);

    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    print(res.body);
    final resJson = jsonDecode(res.body);
    setState(() {
      message = resJson['message'];
    });
  }

  Future getAudio() async {
    final pickedAudio = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav']); // Add other audio extensions as needed
    setState(() {
      selectedAudio = File(pickedAudio!.files.single.path!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            selectedAudio == null
                ? const Text("Please select audio to upload")
                : Text(selectedAudio!.path),
            TextButton.icon(
                onPressed: uploadAudio,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload"))
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: getAudio, child: Icon(Icons.mic)),
    );
  }
}
