part of 'property_cubit.dart';

enum SubmissionStatus {
  initial,
  loading,
  success,
  error,
}

class PropertyState extends Equatable {
  const PropertyState(
      {this.status = SubmissionStatus.initial,
      this.userId = '',
      this.ownerId = '',
      this.message = ''});

  @override
  List<Object> get props => [status, userId, ownerId, message];

  final SubmissionStatus status;
  final String userId;
  final String ownerId;
  final String message;

  PropertyState copyWith(
      {SubmissionStatus? status,
      String? userId,
      String? ownerId,
      String? message}) {
    return PropertyState(
      status: status ?? this.status,
      message: message ?? this.message,
      ownerId: ownerId ?? this.ownerId,
      userId: userId ?? this.userId,
    );
  }
}
