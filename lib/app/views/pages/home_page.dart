import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:catatin/app/views/pages/content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController linkController = TextEditingController();
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      print("ID : $id ==== Status : $status ==== progress : $progress");

      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Catatan"),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const ContentPage()),
            ),
            splashColor: const Color.fromARGB(221, 199, 199, 199),
            child: ListTile(
              leading: const Icon(Icons.note, size: 30),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              title: Text(
                "Catatan $index",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 10),
                      child: TextField(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Directory appDocDir = await getApplicationDocumentsDirectory();
                        String appDocPath = appDocDir.path;

                        await FlutterDownloader.enqueue(
                          url: linkController.text, 
                          savedDir: appDocPath,
                          saveInPublicStorage: true
                        ).then((result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result ?? "Download Selesai"))
                          );
                        });
                      },
                      child: const Text("Import File"),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}