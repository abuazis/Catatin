import 'package:core/core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/md_course_model.dart';
import 'db/md_course_database_helper.dart';

abstract class MdCourseRemoteDataSource {
  Future<MdCourseModel> getMdCourseFromUrl(String url, String saveDir);
}

class MdCourseRemoteDataSourceImpl implements MdCourseRemoteDataSource {
  final MdCourseDatabaseHelper databaseHelper;

  MdCourseRemoteDataSourceImpl({required this.databaseHelper});

  @override
  Future<MdCourseModel> getMdCourseFromUrl(String url, String saveDir) async {
    try {
      String fileName = url.split("/").last;

      await FlutterDownloader.enqueue(
        url: url, 
        savedDir: saveDir,
        saveInPublicStorage: true,
        showNotification: false,
        fileName: fileName,
      );

      var course = MdCourseModel(
        name: fileName, 
        url: url, 
        path: '$saveDir/$fileName',
        createdAt: DateTime.now().toString(),
      );

      int insertedId = await databaseHelper.insertMdCourse(course);
      return course.copyWith(id: insertedId);
    } catch (e) {
      throw ServerException();
    }
  }
}