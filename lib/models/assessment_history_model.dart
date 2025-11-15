import 'dart:convert';
import 'package:hive/hive.dart';

class AssessmentHistoryModel extends HiveObject {
  final String assessmentID;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final String? boardName;
  final String? gradeName;
  final String? subjectName;
  final String? duration;
  final String? topics;

  AssessmentHistoryModel({
    required this.assessmentID,
    required this.data,
    required this.createdAt,
    this.boardName,
    this.gradeName,
    this.subjectName,
    this.duration,
    this.topics,
  });

  Map<String, dynamic> toJson() {
    return {
      'assessmentID': assessmentID,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'boardName': boardName,
      'gradeName': gradeName,
      'subjectName': subjectName,
      'duration': duration,
      'topics': topics,
    };
  }

  factory AssessmentHistoryModel.fromJson(Map<String, dynamic> json) {
    return AssessmentHistoryModel(
      assessmentID: json['assessmentID'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      boardName: json['boardName'] as String?,
      gradeName: json['gradeName'] as String?,
      subjectName: json['subjectName'] as String?,
      duration: json['duration'] as String?,
      topics: json['topics'] as String?,
    );
  }
}

class AssessmentHistoryModelAdapter extends TypeAdapter<AssessmentHistoryModel> {
  @override
  final int typeId = 1;

  @override
  AssessmentHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // Parse the data from JSON string
    final dataJson = fields[1] as String;
    final dataMap = jsonDecode(dataJson) as Map<String, dynamic>;
    
    return AssessmentHistoryModel(
      assessmentID: fields[0] as String,
      data: dataMap,
      createdAt: DateTime.parse(fields[2] as String),
      boardName: fields[3] as String?,
      gradeName: fields[4] as String?,
      subjectName: fields[5] as String?,
      duration: fields[6] as String?,
      topics: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentHistoryModel obj) {
    // Convert data Map to JSON string for reliable storage
    final dataJson = jsonEncode(obj.data);
    
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.assessmentID)
      ..writeByte(1)
      ..write(dataJson)
      ..writeByte(2)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(3)
      ..write(obj.boardName)
      ..writeByte(4)
      ..write(obj.gradeName)
      ..writeByte(5)
      ..write(obj.subjectName)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.topics);
  }
}

