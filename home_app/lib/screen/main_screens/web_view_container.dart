import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String amount;
  const WebViewContainer({super.key, required this.amount});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onNavigationRequest: (NavigationRequest request) {
  //           if (request.url.contains('success')) {
  //             Navigator.pushReplacementNamed(context, '/');
  //             return NavigationDecision.prevent;
  //           }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(''));
  // }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coin Payment",
          style: theme.typography.bodyMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 30.0),
            decoration: BoxDecoration(
              color: theme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                    height: 50,
                    child: Image.asset("assets/images/telebirr.png")),
                const SizedBox(height: 20),
                Text(
                  'How to Pay with Tele Birr', // Title
                  style: theme.typography.headlineSmall,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: theme.primary,
                      child: Text(
                        '1',
                        style: theme.typography.labelSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Send ${widget.amount} ETB to this number 0964604314.',
                        maxLines: 10,
                        style: theme.typography.titleSmall
                            .copyWith(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: theme.primary,
                      child: Text('2', style: theme.typography.labelSmall),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Call or send a message to confirm your payment to 0964604314.',
                        maxLines: 10,
                        style: theme.typography.titleSmall
                            .copyWith(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // WebViewWidget(
          //   controller: controller,
          // ),
        ],
      ),
    );
  }
}
