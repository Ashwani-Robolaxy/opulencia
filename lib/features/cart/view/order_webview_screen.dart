import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:opulencia/utils/strings/route_strings.dart';

class OrderWebviewScreen extends StatefulWidget {
  final String url;
  final String title;

  const OrderWebviewScreen({
    super.key,
    required this.url,
    this.title = 'Payment',
  });

  @override
  State<OrderWebviewScreen> createState() => _OrderWebviewScreenState();
}

class _OrderWebviewScreenState extends State<OrderWebviewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            if (url.toString().contains('payment_complete')) {
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  context.go('/${Routes.bottomNav}');
                }
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // You can monitor URL changes here to detect payment success/failure
            print('Navigating to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When user presses back, return to home/bottom nav
        context.go('/${Routes.bottomNav}');
        return false;
      },
      child: Scaffold(
        appBar: myAppBar(
          context: context,
          title: widget.title,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
