import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FileViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const FileViewerScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button
        if (_webViewController != null) {
          bool canGoBack = await _webViewController!.canGoBack();
          if (canGoBack) {
            await _webViewController!.goBack();
            return false;
          }
        }
        // Exit the screen if webview can't go back
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.fileName),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                // Enable zooming for better readability
                supportZoom: true,
                builtInZoomControls: true,
                displayZoomControls: true,
              ),
              initialUrlRequest: URLRequest(
                url: WebUri.uri(
                  Uri.file(
                    widget.filePath,
                  ),
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading file: ${error.description}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }
}
