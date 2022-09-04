import 'package:get_it/get_it.dart';
import 'package:md_course/data/datasources/db/md_course_database_helper.dart';
import 'package:md_course/data/datasources/md_course_local_data_source.dart';
import 'package:md_course/data/datasources/md_course_remote_data_source.dart';
import 'package:md_course/data/repositories/md_course_repository_impl.dart';
import 'package:md_course/domain/repositories/md_course_repository.dart';
import 'package:md_course/domain/usecases/get_md_course_from_url.dart';
import 'package:md_course/domain/usecases/get_md_courses.dart';
import 'package:md_course/presentation/bloc/md_course_bloc.dart';

final locator = GetIt.instance;

void init() {
  // BLoC
  locator.registerFactory(() => MdCourseBloc(locator(), locator()));

  // Usecase
  locator.registerLazySingleton(() => GetMdCourses(locator()));
  locator.registerLazySingleton(() => GetMdCourseFromUrl(locator()));

  // Repository
  locator.registerLazySingleton<MdCourseRepository>(
    () => MdCourseRepositoryImpl(
      localDataSource: locator(),
      remoteDataSource: locator(),
    ),
  );

  // Data Source
  locator.registerLazySingleton<MdCourseRemoteDataSource>(
    () => MdCourseRemoteDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<MdCourseLocalDataSource>(
    () => MdCourseLocalDataSourceImpl(databaseHelper: locator()),
  );

  // Helper
  locator.registerLazySingleton<MdCourseDatabaseHelper>(
    () => MdCourseDatabaseHelper(),
  );

  // External
}