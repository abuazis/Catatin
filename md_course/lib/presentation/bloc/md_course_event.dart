part of 'md_course_bloc.dart';

abstract class MdCourseEvent extends Equatable {
  const MdCourseEvent();

  @override
  List<Object> get props => [];
}

class MdCourseLoaded extends MdCourseEvent {}

class MdCourseDownloaded extends MdCourseEvent {
  final String url;
  final String saveDir;
  final List<MdCourse> current;

  const MdCourseDownloaded(this.url, this.saveDir, this.current);

  @override
  List<Object> get props => [url, saveDir];
}
