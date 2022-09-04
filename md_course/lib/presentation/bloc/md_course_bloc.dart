import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/md_course.dart';
import '../../domain/usecases/get_md_course_from_url.dart';
import '../../domain/usecases/get_md_courses.dart';

part 'md_course_event.dart';
part 'md_course_state.dart';

class MdCourseBloc extends Bloc<MdCourseEvent, MdCourseState> {
  final GetMdCourses _getMdCourses;
  final GetMdCourseFromUrl _getMdCourseFromUrl;

  MdCourseBloc(this._getMdCourses, this._getMdCourseFromUrl) : super(MdCourseEmpty()) {
    on<MdCourseLoaded>(
      _mdCourseLoadedHandler, 
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<MdCourseDownloaded>(
      _mdCourseDownloadedHandler, 
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  void _mdCourseLoadedHandler(MdCourseLoaded event, Emitter<MdCourseState> emit) async {
    emit(MdCourseLoading());
    final result = await _getMdCourses.execute();

    result.fold(
      (failure) {
        emit(MdCourseError(failure.message));
      }, 
      (data) {
        emit(MdCourseHasData(data));
      },
    );
  }

  void _mdCourseDownloadedHandler(MdCourseDownloaded event, Emitter<MdCourseState> emit) async {
    emit(MdCourseLoading());
    final result = await _getMdCourseFromUrl.execute(event.url, event.saveDir);
    
    result.fold(
      (failure) {
        emit(MdCourseError(failure.message));
      }, 
      (data) {
        emit(MdCourseHasData(event.current + [data]));
      },
    );
  }
}

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}