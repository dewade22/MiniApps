class TimeZoneModel {
  final String id;
  final String displayName;

  const TimeZoneModel({required this.id, required this.displayName});

  factory TimeZoneModel.fromJson(Map<String, dynamic> json) {
    return TimeZoneModel(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
    );
  }
}
