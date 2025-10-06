import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BaseModel extends Equatable {
  const BaseModel();

  Map<String, dynamic> toJson();

  @override
  bool? get stringify => true;

  @override
  String toString() => toJson().toString();
}
