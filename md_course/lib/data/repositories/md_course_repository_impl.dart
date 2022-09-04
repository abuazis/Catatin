import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/md_course.dart';
import '../../domain/repositories/md_course_repository.dart';
import '../datasources/md_course_local_data_source.dart';
import '../datasources/md_course_remote_data_source.dart';

class MdCourseRepositoryImpl implements MdCourseRepository {
  final MdCourseLocalDataSource localDataSource;
  final MdCourseRemoteDataSource remoteDataSource;

  MdCourseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, MdCourse>> getMdCourseFromUrl(String url, String saveDir) async {
    try {
      final result = await remoteDataSource.getMdCourseFromUrl(url, saveDir);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<MdCourse>>> getMdCourses() async {
    final result = await localDataSource.getMdCourses();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}