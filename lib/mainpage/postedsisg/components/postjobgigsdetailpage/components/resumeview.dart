import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
    setState(() {
      isDownloading = true;
    });

    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        bool granted = false;

        if (sdkInt >= 33) {
          // Android 13+ → Need media-specific permissions
          var images = await Permission.photos.request();
          var videos = await Permission.videos.request();
          var audio = await Permission.audio.request();
          granted = images.isGranted || videos.isGranted || audio.isGranted;
        } else if (sdkInt >= 30) {
          // Android 11 & 12
          var status = await Permission.manageExternalStorage.request();
          granted = status.isGranted;
        } else {
          // Android 10 and below
          var status = await Permission.storage.request();
          granted = status.isGranted;
        }

        if (!granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          setState(() => isDownloading = false);
          return;
        }
      }

      // ✅ Download PDF
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        // Save to Downloads folder
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (!downloadsDir.existsSync()) {
          downloadsDir.createSync(recursive: true);
        }

        final filePath =
            '${downloadsDir.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: $filePath')),
        );

        // Open file
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
      setState(() {
        isDownloading = false;
      });
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
