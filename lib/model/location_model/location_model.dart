class Location {
  final int locationCode;
  final String locationName;

  Location({
    required this.locationCode,
    required this.locationName,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationCode: json['LocationCode'],
        locationName: json['LocationName'],
      );

  Map<String, dynamic> toJson() => {
        'LocationCode': locationCode,
        'LocationName': locationName,
      };
}

class CreateLocationRequest {
  final String locationName;

  CreateLocationRequest({required this.locationName});

  Map<String, dynamic> toJson() => {
        'locationName': locationName,
      };
}
