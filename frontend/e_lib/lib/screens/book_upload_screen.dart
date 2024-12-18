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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Color.fromARGB(255, 17, 106, 136),
        ),
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
          SnackBar(
            content: Text('Book uploaded successfully'),
            backgroundColor: Color.fromARGB(255, 17, 106, 136),
          ),
        );
        _clearForm();
      } else {
        _logger.e('Failed to upload book: ${response['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload book: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error uploading book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading book: $e'),
          backgroundColor: Colors.red,
        ),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        title: Text(
          'Upload New Book',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 21, 44),
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 219, 254, 250),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 21, 44),
                          fontFamily: 'Sedan',
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _bookTitleController,
                        label: 'Book Title',
                        icon: Icons.book,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _authorController,
                        label: 'Author',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        icon: Icons.description,
                        maxLines: 4,
                      ),
                      SizedBox(height: 24),
                      _buildFileUploadSection(
                        title: 'Book PDF',
                        fileName: _bookFileName,
                        onTap: () => _pickFile(isCover: false),
                        icon: Icons.upload_file,
                      ),
                      SizedBox(height: 16),
                      _buildFileUploadSection(
                        title: 'Book Cover',
                        fileName: _bookCoverFileName,
                        onTap: () => _pickFile(isCover: true),
                        icon: Icons.image,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _clearForm,
                            icon: Icon(Icons.clear),
                            label: Text('Clear'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 0, 21, 44),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Color.fromARGB(255, 0, 21, 44)),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _uploadBook,
                            icon: Icon(Icons.cloud_upload),
                            label: Text('Upload Book'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 17, 106, 136),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromARGB(255, 100, 204, 199)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 17, 106, 136)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(color: Color.fromARGB(255, 0, 21, 44)),
        ),
      ),
    );
  }

  Widget _buildFileUploadSection({
    required String title,
    required String? fileName,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color.fromARGB(255, 100, 204, 199)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 21, 44),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 219, 254, 250),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Color.fromARGB(255, 17, 106, 136)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fileName ?? 'Click to upload file',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 21, 44),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
