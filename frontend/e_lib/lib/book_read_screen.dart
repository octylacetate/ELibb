import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdfx/pdfx.dart';

class BookRead extends StatefulWidget {
  const BookRead({super.key});

  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  late PDFViewController pdfViewController;
  final pdfController = PdfController(
    document: PdfDocument.openAsset('assets/sample.pdf'),
  );
  static const int _initialPage = 2;

  late PdfController _pdfController;
  bool _isSampleDoc = true;
  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/books/Atomichabits.pdf'),
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 219, 254, 250),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfController,
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
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_isSampleDoc) {
                _pdfController.loadDocument(
                    PdfDocument.openAsset('assets/books/Atomichabits.pdf'));
              } else {
                _pdfController.loadDocument(
                    PdfDocument.openAsset('assets/books/Atomichabits.pdf'));
              }
              _isSampleDoc = !_isSampleDoc;
            },
          ),
        ],
      ),
      body:
          // PDFView(
          //   filePath: 'assets/books/Atomichabits.pdf',
          //   autoSpacing: true,
          //   enableSwipe: true,
          //   pageSnap: true,
          //   swipeHorizontal: true,
          //   onError: (error) {
          //     debugPrint(error);
          //   },
          //   onPageError: (page, error) {
          //     debugPrint('$page: ${error.toString()}');
          //   },
          //   onViewCreated: (PDFViewController vc) {
          //     pdfViewController = vc;
          //   },
          //   onPageChanged: (int? page, int? total) {
          //     debugPrint('page change: $page/n $total');
          //   },
          // ),
          PdfView(
        scrollDirection: Axis.vertical,
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageBuilder: _pageBuilder,
        ),
        controller: _pdfController,
      ),
    );
  }

  PhotoViewGalleryPageOptions _pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.0,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}
