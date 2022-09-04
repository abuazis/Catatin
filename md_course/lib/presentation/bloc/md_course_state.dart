part of 'md_course_bloc.dart';

abstract class MdCourseState extends Equatable {
  const MdCourseState();
  
  @override
  List<Object> get props => [];
}

class MdCourseEmpty extends MdCourseState {}

class MdCourseLoading extends MdCourseState {}

class MdCourseError extends MdCourseState {
  final String message;

  const MdCourseError(this.message);

  @override
  List<Object> get props => [message];
}

class MdCourseHasData extends MdCourseState {
  final List<MdCourse> result;

  const MdCourseHasData(this.result);

  @override
  List<Object> get props => [result];
}