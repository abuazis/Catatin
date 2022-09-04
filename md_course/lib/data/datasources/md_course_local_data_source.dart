import 'package:core/core.dart';

import '../models/md_course_model.dart';
import 'db/md_course_database_helper.dart';

abstract class MdCourseLocalDataSource {
  Future<String> insertMdCourse(MdCourseModel course);
  Future<String> removeMdCourse(MdCourseModel course);
  Future<MdCourseModel?> getMdCourseById(int id);
  Future<List<MdCourseModel>> getMdCourses();
}

class MdCourseLocalDataSourceImpl implements MdCourseLocalDataSource {
  final MdCourseDatabaseHelper databaseHelper;

  MdCourseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<MdCourseModel?> getMdCourseById(int id) async {
    final result = await databaseHelper.getMdCourseById(id);
    if (result != null) {
      return MdCourseModel.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<String> insertMdCourse(MdCourseModel course) async {
    try {
      await databaseHelper.insertMdCourse(course);
      return 'Added to Md Course list';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeMdCourse(MdCourseModel course) async {
    try {
      await databaseHelper.removeMdCourse(course);
      return 'Removed from Md Course list';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
  
  @override
  Future<List<MdCourseModel>> getMdCourses() async {
    final result = await databaseHelper.getMdCourses();
    return result.map((data) => MdCourseModel.fromMap(data)).toList();
  }
}