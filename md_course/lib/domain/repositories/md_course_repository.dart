import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/md_course.dart';

abstract class MdCourseRepository {
  Future<Either<Failure, List<MdCourse>>> getMdCourses();
  Future<Either<Failure, MdCourse>> getMdCourseFromUrl(String url, String saveDir);
}