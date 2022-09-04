import 'package:equatable/equatable.dart';

import '../../domain/entities/md_course.dart';

class MdCourseModel extends Equatable {
  final int? id;
  final String name;
  final String url;
  final String path;
  final String? createdAt;

  const MdCourseModel({
    this.id,
    required this.name,
    required this.url,
    required this.path,
    this.createdAt,
  });

  factory MdCourseModel.fromMap(Map<String, dynamic> map) => MdCourseModel(
    id: map['id'],
    name: map['name'],
    url: map['url'],
    path: map['path'],
    createdAt: map['createdAt']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'url': url,
    'path': path,
    'createdAt': createdAt,
  };

  MdCourse toEntity() => MdCourse(
    id: id!,
    name: name,
    url: url,
    path: path,
    createdAt: createdAt!,
  );

  MdCourseModel copyWith({
    int? id,
    String? name,
    String? url,
    String? path,
    String? createdAt,
  }) => MdCourseModel(
    id: id ?? this.id, 
    name: name ?? this.name, 
    url: url ?? this.url, 
    path: path ?? this.path, 
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    url,
    path,
    createdAt,
  ];
}
