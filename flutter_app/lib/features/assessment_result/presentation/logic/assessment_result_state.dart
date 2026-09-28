part of 'assessment_result_cubit.dart';

@immutable
sealed class AssessmentResultState extends Equatable {
  const AssessmentResultState();

  @override
  List<Object?> get props => [];
}

final class AssessmentResultInitial extends AssessmentResultState {
  const AssessmentResultInitial();
}

final class AssessmentResultLoading extends AssessmentResultState {
  const AssessmentResultLoading();
}

final class AssessmentResultSuccess extends AssessmentResultState {
  const AssessmentResultSuccess(this.result, {this.isStale = false});

  final AssessmentResult result;

  /// True when the newest session on the server was still older than the
  /// session that just finished, i.e. the backend had not received it yet.
  final bool isStale;

  @override
  List<Object?> get props => [result, isStale];
}

final class AssessmentResultFailure extends AssessmentResultState {
  const AssessmentResultFailure(this.message);

  /// Technical detail for logs; the UI shows its own localized message.
  final String message;

  @override
  List<Object?> get props => [message];
}
