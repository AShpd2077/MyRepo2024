import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My PDF Viewer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PDFViewerPage(),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  const PDFViewerPage({super.key});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? _filePath;
  bool _isLoading = false;
  Key _pdfKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My PDF Viewer")),
      body: Stack(
        children: [
          _filePath != null
              ? PDFView(
                  key: _pdfKey,
                  filePath: _filePath!,
                  onRender: (pages) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    print("Error while loading PDF: $error");
                  },
                  onPageError: (page, error) {
                    setState(() {
                      _isLoading = false;
                    });
                    print("Error on page $page: $error");
                  },
                )
              : const Center(child: Text("Select a PDF to view")),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        child: const Icon(Icons.file_open),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _isLoading = true;
        _pdfKey = UniqueKey();
      });
    }
  }
}
