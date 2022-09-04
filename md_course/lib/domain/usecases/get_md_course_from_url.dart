import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/md_course.dart';
import '../repositories/md_course_repository.dart';

class GetMdCourseFromUrl {
  final MdCourseRepository repository;

  GetMdCourseFromUrl(this.repository);

  Future<Either<Failure, MdCourse>> execute(String url, String saveDir) {
    return repository.getMdCourseFromUrl(url, saveDir);
  }
}