import 'dart:typed_data';
import 'package:e_lib/route_persistence.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class BookRead extends StatefulWidget {
  final String bookUrl;
  final bool isLoggedIn;
  final Function logout;

  const BookRead({
    required this.bookUrl,
    required this.isLoggedIn,
    required this.logout,
    Key? key,
  }) : super(key: key);

  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  final RoutePersistence routePersistence = RoutePersistence();

  PdfController? _pdfController;
  bool _isLoading = true;

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
      );
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

  Future<Uint8List> fetchPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    routePersistence.saveLastRoute('/book-read/${widget.bookUrl}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 254, 250),
        actions: <Widget>[
          if (_pdfController != null) ...[
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                _pdfController?.previousPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 100),
                );
              },
            ),
            PdfPageNumber(
              controller: _pdfController!,
              builder: (_, loadingState, page, pagesCount) => Container(
                alignment: Alignment.center,
                child: Text(
                  '$page/${pagesCount ?? 0}',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                _pdfController?.nextPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 100),
                );
              },
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PdfView(
              scrollDirection: Axis.vertical,
              controller: _pdfController!,
            ),
    );
  }
}
