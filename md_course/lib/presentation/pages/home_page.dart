import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/md_course_bloc.dart';
import 'content_page.dart';

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
    askPermission();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);

    BlocProvider.of<MdCourseBloc>(context, listen: false).add(MdCourseLoaded());
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> askPermission() async {
    final status = Permission.storage.status;

    if (!(await status.isGranted)) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final mdCourseBlocProvider = BlocProvider.of<MdCourseBloc>(context);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Catatan"),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MdCourseBloc, MdCourseState>(
              builder: (context, state) {
                if (state is MdCourseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MdCourseHasData) {
                  return ListView.builder(
                    itemCount: state.result.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ContentPage(state.result[index].path)),
                        ),
                        splashColor: const Color.fromARGB(221, 199, 199, 199),
                        child: ListTile(
                          leading: const Icon(Icons.note, size: 30),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          title: Text(
                            state.result[index].name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            state.result[index].url,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MdCourseError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                      child: TextField(controller: linkController),
                    ),
                    BlocConsumer<MdCourseBloc, MdCourseState>(
                      listener: (context, state) {
                        if (state is MdCourseError) {
                          scaffold.showSnackBar(SnackBar(content: Text(state.message)));
                        } else if (state is MdCourseLoaded) {
                          scaffold.showSnackBar(const SnackBar(content: Text("Download Selesai")));
                        }
                      },
                      builder: (context, state) {
                        if (state is MdCourseHasData || state is MdCourseEmpty) {
                          return ElevatedButton(
                            onPressed: () async {
                              if (linkController.text.isNotEmpty) {
                                Directory appDocDir = await getApplicationDocumentsDirectory();
                                String appDocPath = appDocDir.path;

                                final status = Permission.storage.status;

                                if ((await status.isGranted)) {
                                  mdCourseBlocProvider.add(
                                    MdCourseDownloaded(
                                      linkController.text.replaceFirst("github.com", "raw.githubusercontent.com").replaceFirst("/blob/", "/"), 
                                      Platform.isIOS ? appDocPath : "/storage/emulated/0/Download", 
                                      state is MdCourseHasData ? state.result : [],
                                    ),
                                  );

                                  setState(() {
                                    linkController.clear();
                                  });

                                  navigator.pop();
                                } else {
                                  await Permission.storage.request();
                                }
                              }
                            },
                            child: const Text("Import File"),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
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
