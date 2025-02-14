import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'package:e_lib/service/apiservicebooks.dart';

class BookRead extends StatefulWidget {
  final String bookUrl;
  final String bookId;

  const BookRead({
    required this.bookUrl,
    required this.bookId,
    Key? key,
  }) : super(key: key);

  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  PdfController? _pdfController;
  bool _isLoading = true;
  final BookService _bookService = BookService();
  int _totalPages = 0;
  int _currentPage = 1;
  final TextEditingController _pageController = TextEditingController();
  bool _isJumping = false;

  @override
  void initState() {
    super.initState();
    _initializePdfController();
  }

  Future<void> _initializePdfController() async {
    try {
      final pdfData = await fetchPdf(widget.bookUrl);
      _pdfController = PdfController(
        document: PdfDocument.openData(pdfData),
        initialPage: 1,
      );
      
      // Get total pages after document is loaded
      final doc = await _pdfController?.document;
      _totalPages = await doc?.pagesCount ?? 0;
      _pageController.text = '1';
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updatePage(int newPage) {
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
        if (!_isJumping) {
          _pageController.text = newPage.toString();
        }
      });
      _updateReadingProgress();
    }
  }

  void _jumpToPage() {
    setState(() {
      _isJumping = true;
    });
    int pageNumber = int.tryParse(_pageController.text) ?? _currentPage;
    if (pageNumber < 1) pageNumber = 1;
    if (pageNumber > _totalPages) pageNumber = _totalPages;
    
    _pageController.text = pageNumber.toString();
    _pdfController?.jumpToPage(pageNumber - 1).then((_) {
      setState(() {
        _isJumping = false;
      });
    });
  }

  Future<void> _updateReadingProgress() async {
    if (_totalPages > 0) {
      final progress = _currentPage / _totalPages;
      try {
        await _bookService.updateReadingProgress(
          widget.bookId,
          progress,
        );
      } catch (e) {
        debugPrint('Error updating reading progress: $e');
      }
    }
  }

  Future<Uint8List> fetchPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page $_currentPage of $_totalPages'),
            const SizedBox(width: 20),
            SizedBox(
              width: 70,
              child: TextField(
                controller: _pageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (_) => _jumpToPage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: _jumpToPage,
            ),
          ],
        ),
      ),
      body: _pdfController == null
          ? const Center(child: Text('Error loading PDF'))
          : PdfView(
              controller: _pdfController!,
              onPageChanged: _updatePage,
              scrollDirection: Axis.horizontal,
            ),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
