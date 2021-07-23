import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInputW extends StatefulWidget {
  final Function onSelectImage;

  ImageInputW(this.onSelectImage);

  @override
  _ImageInputWState createState() => _ImageInputWState();
}

class _ImageInputWState extends State<ImageInputW> {
  File _storedImage;

  Future<void> _takePicture() async {
    try {
      final _picker =
          ImagePicker(); //instantiate ImagePicker is mandatory for latest version
      final imageFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path); //Cast File to an XFile type Object
      });
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);
      // print('fileName: $fileName');
      final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text(
              'Take Picture',
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
