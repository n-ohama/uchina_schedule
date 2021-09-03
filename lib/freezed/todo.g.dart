// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$_$_TodoFromJson(Map<String, dynamic> json) {
  return _$_Todo(
    id: json['id'] as int,
    title: json['title'] as String,
    create: DateTime.parse(json['create'] as String),
    schedule: json['schedule'] == null
        ? null
        : DateTime.parse(json['schedule'] as String),
    notify: json['notify'] as bool? ?? false,
    favorite: json['favorite'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_TodoToJson(_$_Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'create': instance.create.toIso8601String(),
      'schedule': instance.schedule?.toIso8601String(),
      'notify': instance.notify,
      'favorite': instance.favorite,
    };
