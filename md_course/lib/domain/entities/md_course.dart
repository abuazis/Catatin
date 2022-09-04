import 'package:equatable/equatable.dart';

class MdCourse extends Equatable {
  final int id;
  final String name;
  final String url;
  final String path;
  final String createdAt;

  const MdCourse({
    required this.id,
    required this.name,
    required this.url,
    required this.path,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    url,
    path,
    createdAt,
  ];
}