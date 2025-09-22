import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ResumePdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  const ResumePdfViewerPage({super.key, required this.pdfUrl});

  @override
  State<ResumePdfViewerPage> createState() => _ResumePdfViewerPageState();
}

class _ResumePdfViewerPageState extends State<ResumePdfViewerPage> {
  bool isDownloading = false;
  Future<void> _sharePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/shared_resume.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'My Resume PDF',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load PDF for sharing.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while sharing: $e')),
      );
    }
  }

  Future<void> _downloadPdf() async {
    setState(() => isDownloading = true);

    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        // ✅ Use app-specific directory (no extra permission required)
        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF saved successfully!')),
        );

        // ✅ Open PDF using open_file
        await OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download PDF.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      appBar: AppBar(
        title: const Text('Resume Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePdf,
            tooltip: 'Share PDF',
          ),
          IconButton(
            icon: isDownloading
                ?  SizedBox(
              width: width * 0.05,   // 5% of screen width (≈ 20px on 400px screen)
              height: height * 0.025,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Icon(Icons.download),
            onPressed: isDownloading ? null : _downloadPdf,
            tooltip: 'Download PDF',
          ),
        ],

      ),
      body: PDF().fromUrl(
        widget.pdfUrl,
        placeholder: (progress) =>
            Center(child: Text('$progress %')),
        errorWidget: (error) =>
            Center(child: Text('Failed to load PDF: $error')),
      ),
    );
  }
}
