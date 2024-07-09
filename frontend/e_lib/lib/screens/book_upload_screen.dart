import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:e_lib/service/apiservicebooks.dart';

class BookUploadScreen extends StatefulWidget {
  @override
  _BookUploadScreenState createState() => _BookUploadScreenState();
}

class _BookUploadScreenState extends State<BookUploadScreen> {
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final BookService bookService = BookService();
  final Logger _logger = Logger();
  Uint8List? _bookBytes;
  String? _bookFileName;
  Uint8List? _bookCoverBytes;
  String? _bookCoverFileName;

  void _pickFile({required bool isCover}) async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = isCover ? 'image/*' : 'application/pdf';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files!.isEmpty) return;
        final file = files.first;
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            if (isCover) {
              _bookCoverBytes = reader.result as Uint8List?;
              _bookCoverFileName = file.name;
            } else {
              _bookBytes = reader.result as Uint8List?;
              _bookFileName = file.name;
            }
          });
        });

        reader.readAsArrayBuffer(file);
      });
    } catch (e) {
      _logger.e('An error occurred while picking the file: $e');
    }
  }

  void _uploadBook() async {
    final bookTitle = _bookTitleController.text;
    final author = _authorController.text;
    final description = _descriptionController.text;

    if (bookTitle.isEmpty ||
        author.isEmpty ||
        description.isEmpty ||
        _bookBytes == null ||
        _bookFileName == null ||
        _bookCoverBytes == null ||
        _bookCoverFileName == null) {
      _logger.e('All fields are required');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      final response = await bookService.uploadBook(
        bookTitle,
        _bookBytes!,
        _bookFileName!,
        _bookCoverBytes!,
        _bookCoverFileName!,
        author,
        description,
      );
      if (response['statusCode'] == 200) {
        _logger.i('Book uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book uploaded successfully')),
        );
      } else {
        _logger.e('Failed to upload book: ${response['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to upload book: ${response['message']}')),
        );
      }
    } catch (e) {
      _logger.e('Error uploading book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bookTitleController,
              decoration: InputDecoration(labelText: 'Book Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickFile(isCover: false),
              child: Text('Select Book'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickFile(isCover: true),
              child: Text('Select Book Cover'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadBook,
              child: Text('Upload Book'),
            ),
          ],
        ),
      ),
    );
  }
}
