import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextRecognizer textRecognizer;
  late ImagePicker imagePicker;

  String? pickedImagePath;
  String recognizedText = "";

  bool isRecognizing = false;

  @override
  void initState() {
    super.initState();

    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    imagePicker = ImagePicker();
  }

  void _pickImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      setState(() {
        pickedImagePath = null;
        recognizedText = "";
      });
      return;
    }

    setState(() {
      pickedImagePath = pickedImage.path;
      isRecognizing = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedImage.path);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      recognizedText = "";

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text}\n";
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isRecognizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Text Recognition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (pickedImagePath != null) ...[
              Image.file(
                File(pickedImagePath!),
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick an image'),
            ),
            if (isRecognizing) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
            if (recognizedText.isNotEmpty) ...[
              const SizedBox(height: 20),
              Flex(
                direction: Axis.vertical,
                children: [
                  SelectableText(
                    recognizedText,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
