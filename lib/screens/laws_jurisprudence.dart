import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LawsJurisprudence extends StatefulWidget {
  const LawsJurisprudence({super.key});

  @override
  _LawsJurisprudenceState createState() => _LawsJurisprudenceState();
}

class _LawsJurisprudenceState extends State<LawsJurisprudence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Laws & Jurisprudence'),
      ),
      body: const WebView(
        initialUrl: 'https://jur.ph/jurisprudence',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
