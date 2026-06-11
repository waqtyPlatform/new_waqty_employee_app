class HelpQuestionsResponseModel {
  final bool success;
  final List<HelpQuestionModel> data;

  HelpQuestionsResponseModel({required this.success, required this.data});

  factory HelpQuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return HelpQuestionsResponseModel(
      success: json['success'] ?? false,
      data:
          (json['data'] as List?)
              ?.map((item) => HelpQuestionModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class HelpQuestionModel {
  final String uuid;
  final String question;
  final String answer;

  HelpQuestionModel({
    required this.uuid,
    required this.question,
    required this.answer,
  });

  factory HelpQuestionModel.fromJson(Map<String, dynamic> json) {
    return HelpQuestionModel(
      uuid: json['uuid'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}
