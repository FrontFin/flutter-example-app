import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebView Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'JSBridge', // This is the channel name you can use to listen from JS
        onMessageReceived: (JavaScriptMessage message) {
          _handleMessage(message.message);
        },
      )
      ..addJavaScriptChannel(
        'ReactNativeWebView', // This will capture messages from window.ReactNativeWebView.postMessage
        onMessageReceived: (JavaScriptMessage message) {
          _handleMessage(message.message);
        },
      )
      ..loadRequest(Uri.parse(
          'https://web.meshconnect.com/b2b-iframe/e1880c6d-5af8-4634-3182-08dba58a99a5/broker-connect?auth_code=RPoKGKmIHkECWS53gmYFE2OYcAyXYb2rcx0Yd8c3adBXvmL7ZZTeDrOiN7RD_w7aATmIHeS5njs7smmEs9Javw&restrictMultipleAccounts=true&link_style=eyJwYyI6IiMwMzdGRkYiLCJwdCI6IiNGRkZGRkYiLCJzYyI6IiMwRUNBRTAiLCJzdCI6IiMwMDAwMDAiLCJiciI6NS4wMCwiaXIiOjAuMDAsImlvIjowLjM3MDAwMDAwLCJ0IjoibGFiZWwiLCJoYyI6ZmFsc2UsInRoIjpudWxsfQ%3d%3d&integration_id=47624467-e52e-4938-a41a-7926b6c27acf'));
  }

  // Function to handle incoming JavaScript messages
  void _handleMessage(String message) {
    print('Message from JS: $message');
    // Handle the message accordingly in your Flutter app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message from JS: $message')),
    );
  }

  // Function to clear cookies and cache
  void _clearCookies() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();
    print('Cookies cleared');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cookies and cache cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesh WebView'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearCookies, // Call the function to clear cookies
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
