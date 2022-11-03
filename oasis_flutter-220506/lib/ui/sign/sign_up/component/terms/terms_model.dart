import 'package:equatable/equatable.dart';

class TermsModel extends Equatable {
  final String title;
  final bool required;
  final String? version;
  final String content;

  TermsModel({
    required this.title,
    this.required = false,
    this.version,
    required this.content,
  });

  @override
  List<Object?> get props => [
        title,
        required,
        content,
        version,
      ];
}