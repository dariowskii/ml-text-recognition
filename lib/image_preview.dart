import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 203, 203, 203),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: imagePath == null
          ? const Center(
              child: Text(
                "No image selected",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
            ),
    );
  }
}
