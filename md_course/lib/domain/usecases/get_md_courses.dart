import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../entities/md_course.dart';
import '../repositories/md_course_repository.dart';

class GetMdCourses {
  final MdCourseRepository repository;

  GetMdCourses(this.repository);

  Future<Either<Failure, List<MdCourse>>> execute() {
    return repository.getMdCourses();
  }
}