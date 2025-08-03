class Location {
  String? locationID;
  String? locationName;
  String? locationCode;
  String? locationAddress;
  String? locationCity;
  String? locationState;
  String? locationCountry;
  String? postalCode;
  bool? isUseForGeoFencing;
  double? longitude;
  double? latitude;
  double? distance;
  String? errorMessage;
  bool? isErrorFound;

  Location({
     this.locationID,
     this.locationName,
     this.locationCode,
     this.locationAddress,
     this.locationCity,
     this.locationState,
     this.locationCountry,
     this.postalCode,
     this.isUseForGeoFencing,
     this.longitude,
     this.latitude,
     this.distance,
     this.errorMessage,
     this.isErrorFound,
  });

  // Factory method to create an object from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationID: json['LocationID'],
      locationName: json['LocationName'],
      locationCode: json['LocationCode'],
      locationAddress: json['LocationAddress'],
      locationCity: json['LocationCity'],
      locationState: json['LocationState'],
      locationCountry: json['LocationCountry'],
      postalCode: json['PostalCode'],
      isUseForGeoFencing: json['IsUseForGeoFencing'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      distance: json['Distance'],
      errorMessage: json['ErrorMessage'],
      isErrorFound: json['IsErrorFound'],
    );
  }

  // Method to convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'LocationID': locationID,
      'LocationName': locationName,
      'LocationCode': locationCode,
      'LocationAddress': locationAddress,
      'LocationCity': locationCity,
      'LocationState': locationState,
      'LocationCountry': locationCountry,
      'PostalCode': postalCode,
      'IsUseForGeoFencing': isUseForGeoFencing,
      'Longitude': longitude,
      'Latitude': latitude,
      'Distance': distance,
      'ErrorMessage': errorMessage,
      'IsErrorFound': isErrorFound,
    };
  }

  Location copyWith({
    String? locationID,
    String? locationName,
    String? locationCode,
    String? locationAddress,
    String? locationCity,
    String? locationState,
    String? locationCountry,
    String? postalCode,
    bool? isUseForGeoFencing,
    double? longitude,
    double? latitude,
    double? distance,
    String? errorMessage,
    bool? isErrorFound,
  }) {
    return Location(
      locationID: locationID ?? this.locationID,
      locationName: locationName ?? this.locationName,
      locationCode: locationCode ?? this.locationCode,
      locationAddress: locationAddress ?? this.locationAddress,
      locationCity: locationCity ?? this.locationCity,
      locationState: locationState ?? this.locationState,
      locationCountry: locationCountry ?? this.locationCountry,
      postalCode: postalCode ?? this.postalCode,
      isUseForGeoFencing: isUseForGeoFencing ?? this.isUseForGeoFencing,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      distance: distance ?? this.distance,
      errorMessage: errorMessage ?? this.errorMessage,
      isErrorFound: isErrorFound ?? this.isErrorFound,
    );
  }
}
