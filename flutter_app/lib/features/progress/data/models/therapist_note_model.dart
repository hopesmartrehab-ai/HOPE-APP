class TherapistNoteModel {
  const TherapistNoteModel({
    required this.note,
    required this.therapistName,
    required this.reviewedDate,
  });

  final String note;
  final String therapistName;
  final String reviewedDate;

  factory TherapistNoteModel.fromJson(Map<String, dynamic> json) {
    return TherapistNoteModel(
      note: json['note'] as String,
      therapistName: json['therapistName'] as String,
      reviewedDate: json['reviewedDate'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'note': note,
    'therapistName': therapistName,
    'reviewedDate': reviewedDate,
  };
}
