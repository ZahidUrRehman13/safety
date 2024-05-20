import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// #enddocregion platform_imports
class WebViewScreen extends StatefulWidget {
  String navUrl;
  int route;
  WebViewScreen({super.key, required this.navUrl, required this.route});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<PDFViewController> _controllerPdf = Completer<PDFViewController>();
  late final WebViewController _controller;
  double percentage = 0.0;
  bool loading = true;
  bool isReady = true;

  @override
  void initState() {
    super.initState();

    if (widget.route == 0) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
              percentage = progress.toDouble();
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Page resource error');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange change) {
              debugPrint('url change to ${change.url}');
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(widget.navUrl));

      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
      }
      // #enddocregion platform_features

      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFd2dfff),
                  Color(0xFFced2ff),
                  Color(0xFFcdcfff),
                  Color(0xFFc3caff),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: widget.route == 1
                ? PDF(
                    enableSwipe: true,
                    autoSpacing: false,
                    pageFling: false,
                  ).cachedFromUrl(widget.navUrl, errorWidget: (widget) {
                    return Center(
                      child: Text(
                        "Internet Connection Failed",
                        style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                      ),
                    );
                  })
                : loading
                    ? Center(
                        child: Text(
                          "Loading...",
                          style: GoogleFonts.montserrat(fontSize: 13, color: Colors.black),
                        ),
                      )
                    : WebViewWidget(controller: _controller)),
      ),
    );
  }
}
