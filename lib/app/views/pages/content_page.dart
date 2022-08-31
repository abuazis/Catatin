import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String data = "### Haii";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan X"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Markdown(
          data: data,
        ),
      ),
    );
  }
}