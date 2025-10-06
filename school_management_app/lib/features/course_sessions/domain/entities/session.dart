import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final String courseOfferingId;
  final String teacherId;
  final String sessionType; // 'lecture', 'lab', 'tutorial', 'exam'
  final String? title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final bool isCancelled;
  final String? cancellationReason;

  const Session({
    required this.id,
    required this.courseOfferingId,
    required this.teacherId,
    required this.sessionType,
    this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.isCancelled = false,
    this.cancellationReason,
  });

  @override
  List<Object?> get props => [
        id,
        courseOfferingId,
        teacherId,
        sessionType,
        title,
        description,
        startTime,
        endTime,
        location,
        isCancelled,
        cancellationReason,
      ];

  Session copyWith({
    String? id,
    String? courseOfferingId,
    String? teacherId,
    String? sessionType,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    bool? isCancelled,
    String? cancellationReason,
  }) {
    return Session(
      id: id ?? this.id,
      courseOfferingId: courseOfferingId ?? this.courseOfferingId,
      teacherId: teacherId ?? this.teacherId,
      sessionType: sessionType ?? this.sessionType,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      isCancelled: isCancelled ?? this.isCancelled,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  bool get isUpcoming => DateTime.now().isBefore(startTime);
  bool get isOngoing => DateTime.now().isAfter(startTime) && 
                       DateTime.now().isBefore(endTime);
  bool get isPast => DateTime.now().isAfter(endTime);
  Duration get duration => endTime.difference(startTime);
}
