import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:e_lib/service/apiservicebooks.dart';
import 'dart:html' as html;

// Import colors from main.dart
const primaryColor = Color.fromARGB(255, 219, 254, 250);
const secondaryColor = Color.fromARGB(255, 17, 106, 136);
const accentColor = Color.fromARGB(255, 100, 204, 199);
const textDarkColor = Color.fromARGB(255, 0, 21, 44);

class BookUploadScreen extends StatefulWidget {
  const BookUploadScreen({Key? key}) : super(key: key);

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
  String _selectedGenre = 'Fantasy';

  final List<String> _genres = [
    'Fantasy',
    'Sci-fi',
    'Mystery',
    'Romance',
    'Historical-fi',
    'Thriller',
    'Non-fiction',
    'Young-adult',
    "Children's-literature"
  ];

  Future<void> pickBookFile() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'application/pdf';
      uploadInput.click();

      await uploadInput.onChange.first;
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;

        setState(() {
          _bookBytes = Uint8List.fromList(reader.result as List<int>);
          _bookFileName = file.name;
        });
      }
    } catch (e) {
      _logger.e('Error selecting PDF file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting PDF file: $e')),
      );
    }
  }

  Future<void> pickCoverImage() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      await uploadInput.onChange.first;
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;

        setState(() {
          _bookCoverBytes = Uint8List.fromList(reader.result as List<int>);
          _bookCoverFileName = file.name;
        });
      }
    } catch (e) {
      _logger.e('Error selecting cover image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting cover image: $e')),
      );
    }
  }

  void _uploadBook() async {
    if (_bookTitleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _bookBytes == null ||
        _bookCoverBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select files')),
      );
      return;
    }

    try {
      final response = await bookService.uploadBook(
        _bookTitleController.text,
        _bookBytes!,
        _bookFileName!,
        _bookCoverBytes!,
        _bookCoverFileName!,
        _authorController.text,
        _descriptionController.text,
        _selectedGenre,
      );

      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book uploaded successfully')),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload book: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading book: $e')),
      );
    }
  }

  void _clearForm() {
    _bookTitleController.clear();
    _authorController.clear();
    _descriptionController.clear();
    setState(() {
      _bookBytes = null;
      _bookFileName = null;
      _bookCoverBytes = null;
      _bookCoverFileName = null;
      _selectedGenre = 'Fantasy';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Upload Book',
          style: TextStyle(color: textDarkColor, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Details',
                        style: TextStyle(
                          color: textDarkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _bookTitleController,
                        decoration: InputDecoration(
                          labelText: 'Book Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _authorController,
                        decoration: InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGenre,
                        decoration: InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: _genres.map((String genre) {
                          return DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedGenre = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Files',
                        style: TextStyle(
                          color: textDarkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: pickBookFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              _bookFileName ?? 'Select PDF File',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: pickCoverImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              _bookCoverFileName ?? 'Select Cover Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _uploadBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Upload Book',
                  style: TextStyle(
                    color: textDarkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

