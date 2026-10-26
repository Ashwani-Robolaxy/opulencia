import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceScreen extends ConsumerStatefulWidget {
  final String url;

  const InvoiceScreen({super.key, required this.url});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends ConsumerState<InvoiceScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) async {
              if (request.url.endsWith('.pdf') || request.url.contains('/download')) {
                await _downloadFile(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  Future<void> _downloadFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not download the file.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: "Invoice",
        action: [
          IconButton(
            onPressed: () {
              if (widget.url.isNotEmpty) {
                _downloadFile(widget.url);
              }
            },
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: widget.url.isNotEmpty
          ? WebViewWidget(controller: _controller)
          : Center(
              child: Text(
                'No Invoice Found!',
                style: Styles.mediumBoldText(context),
              ),
            ),
    );
  }
}
