import 'package:equatable/equatable.dart';

class Terms extends Equatable {
  final String? joinTerms; // join_terms,
  final String? informationProcessTerms; // information_process_terms,
  final String? locationServiceTerms; // location_service_terms,
  final String? religionTerms; // religion_terms,
  final String? marketingTerms; // marketing_terms
  final String? crimeTerms;

  Terms({
    this.joinTerms,
    this.informationProcessTerms,
    this.locationServiceTerms,
    this.religionTerms,
    this.marketingTerms,
    this.crimeTerms,
  });

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      joinTerms: json["join_terms"],
      informationProcessTerms: json["information_process_terms"],
      locationServiceTerms: json["location_service_terms"],
      religionTerms: json["religion_terms"],
      marketingTerms: json["marketing_terms"],
        crimeTerms: json['crime_terms'],
    );
  }

  @override
  List<Object?> get props => [
        joinTerms,
        informationProcessTerms,
        locationServiceTerms,
        religionTerms,
        marketingTerms,
    crimeTerms,
      ];
}
