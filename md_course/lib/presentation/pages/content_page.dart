import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ContentPage extends StatefulWidget {
  final String filePath;

  const ContentPage(this.filePath ,{Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String _content = "";

  @override
  void initState() {
    super.initState();
    _readContentFile();
  }

  void _readContentFile() async {
    final contentFile = File(widget.filePath);
    final data = await contentFile.readAsString(encoding: utf8);
    setState(() {
      _content = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
      ),
      body: SizedBox(
        child: MarkdownWidget(
          data: _content,
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}