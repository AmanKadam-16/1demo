import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/taLocationDetails.dart';
import 'package:time_attendance/model/Masters/talocation.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  final locations = <Location>[].obs;
  final filteredLocations = <Location>[].obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final isSortAscending = true.obs;
   final RxBool isAutoFillingLocation = false.obs;

  AuthLogin? _authLogin;

  @override
  void onInit() {
    print('LocationController: onInit called');
    super.onInit();
    initializeAuthLocation();
  }

  Future<void> initializeAuthLocation() async {
    print('LocationController: Initializing auth location');
    try {
      MTAResult objResult = MTAResult();
      final userInfo = await PlatformSessionManager.getUserInfo();
      print('LocationController: Retrieved user info: ${userInfo != null ? 'not null' : 'null'}');
      
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        print('LocationController: Attempting login with CompanyCode: $companyCode, LoginID: $loginID');
        
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        print('LocationController: Auth login ${_authLogin != null ? 'successful' : 'failed'}');
        
        fetchLocation();
      }
    } catch (e) {
      print('LocationController: Error in initializeAuthLocation: $e');
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchLocation() async {
    print('LocationController: Fetching locations');
    try {
      if (_authLogin == null) {
        print('LocationController: Auth login is null, cannot fetch locations');
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      print('LocationController: Loading state set to true');

      MTAResult result = MTAResult();
      print('LocationController: Calling API to get locations');
      List<TALocation> apiLocations =
          await TALocationDetails().GetAllTALocations(_authLogin!, result);
      print('LocationController: Retrieved ${apiLocations.length} locations from API');

      locations.value = apiLocations
          .map((loc) {
            print('LocationController: Mapping location - ID: ${loc.LocationID}, Name: ${loc.LocationName}');
            return Location(
              locationID: loc.LocationID,
              locationName: loc.LocationName,
              locationCode: loc.LocationCode,
              locationAddress: loc.Address,
              locationCity: loc.City,
              locationState: loc.State,
              locationCountry: loc.Country,
              postalCode: loc.PostalCode,
              isUseForGeoFencing: loc.IsUseForGeoFencing,
              longitude: loc.Longitude,
              latitude: loc.Latitude,
              distance: loc.Distance,
              errorMessage: loc.ErrorMessage,
              isErrorFound: loc.IsErrorFound,
            );
          })
          .toList();

      print('LocationController: Mapped ${locations.length} locations');
      updateSearchQuery(searchQuery.value);
      
    } catch (e) {
      print('LocationController: Error in fetchLocation: $e');
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
      print('LocationController: Loading state set to false');
    }
  }
  Future<Location?> getCurrentLocation() async {
  try {
    isAutoFillingLocation.value = true;
    print('LocationController: Fetching current location');
    
    // First check if we have location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Get current location from TALocationDetails
    TALocation currentLocation = await TALocationDetails().GetCurrentLocation();
    
    // Add null checks and validation
    if (currentLocation.Latitude == 0 && currentLocation.Longitude == 0) {
      throw Exception('Invalid coordinates received');
    }

    // Create and validate location object
    Location location = Location(
      latitude: currentLocation.Latitude,
      longitude: currentLocation.Longitude,
      locationAddress: currentLocation.Address.isNotEmpty ? currentLocation.Address : null,
      locationCity: currentLocation.City.isNotEmpty ? currentLocation.City : null,
      locationState: currentLocation.State.isNotEmpty ? currentLocation.State : null,
      locationCountry: currentLocation.Country.isNotEmpty ? currentLocation.Country : null,
      postalCode: currentLocation.PostalCode.isNotEmpty ? currentLocation.PostalCode : null,
    );

    // Validate coordinates
    if (location.latitude == null || location.longitude == null) {
      throw Exception('Failed to get valid coordinates');
    }

    print('LocationController: Successfully got location - Lat: ${location.latitude}, Lng: ${location.longitude}');
    return location;
  } catch (e) {
    print('LocationController: Error in getCurrentLocation: $e');
    MTAToast().ShowToast('Failed to get current location: $e');
    return null;
  } finally {
    isAutoFillingLocation.value = false;
  }
}

 Future<void> handleGeoFencingToggle(bool value, Function(double lat, double lng) onLocationFetched) async {
  if (!value) return;
  
  try {
    isAutoFillingLocation.value = true;
    
    // Get the location
    TALocation currentLocation = await TALocationDetails().GetCurrentLocation();
    
    // Check if there was an error
    if (currentLocation.IsErrorFound) {
      MTAToast().ShowToast(currentLocation.ErrorMessage);
      return;
    }

    // Check if coordinates are valid
    if (currentLocation.Latitude != 0 && currentLocation.Longitude != 0) {
      onLocationFetched(currentLocation.Latitude, currentLocation.Longitude);
    } else {
      MTAToast().ShowToast('Could not determine your current location. Please check your location settings and try again.');
    }
  } catch (e) {
    MTAToast().ShowToast('Error getting current location: ${e.toString()}');
  } finally {
    isAutoFillingLocation.value = false;
  }
}
  // Future<void> saveLocation(Location location) async {
  //   print('LocationController: Saving location - ID: ${location.locationID}, Name: ${location.locationName}');
  //   try {
  //     if (_authLogin == null) {
  //       print('LocationController: Auth login is null, cannot save location');
  //       throw Exception('Authentication not initialized');
  //     }

  //     isLoading.value = true;
  //     MTAResult result = MTAResult();

  //     TALocation apiLocation = TALocation()
  //       ..LocationID = location.locationID
  //       ..LocationName = location.locationName
  //       ..LocationCode = location.locationCode
  //       ..Address = location.locationAddress
  //       ..City = location.locationCity
  //       ..State = location.locationState
  //       ..Country = location.locationCountry
  //       ..PostalCode = location.postalCode
  //       ..IsUseForGeoFencing = location.isUseForGeoFencing
  //       ..Latitude = location.latitude
  //       ..Longitude = location.longitude
  //       ..Distance = location.distance
  //       ..ErrorMessage = location.errorMessage
  //       ..IsErrorFound = location.isErrorFound;

  //     print('LocationController: Mapped location to API model');
  //     bool success;
  //     if (location.locationID?.isEmpty ?? true) {
  //       print('LocationController: Creating new location');
  //       success = await TALocationDetails().Save(_authLogin!, apiLocation, result);
  //     } else {
  //       print('LocationController: Updating existing location');
  //       success = await TALocationDetails().Update(_authLogin!, apiLocation, result);
  //     }

  //     print('LocationController: Save/Update operation ${success ? 'successful' : 'failed'}');
  //     if (success) {
  //       MTAToast().ShowToast(result.ResultMessage);
  //       await fetchLocation();
  //     } else {
  //       print('LocationController: Operation failed - ${result.ErrorMessage}');
  //       MTAToast().ShowToast(result.ResultMessage);
  //       throw Exception(result.ErrorMessage);
  //     }
  //   } catch (e) {
  //     print('LocationController: Error in saveLocation: $e');
  //     MTAToast().ShowToast(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> saveLocation(Location location) async {
  print('LocationController: Saving location - ID: ${location.locationID}, Name: ${location.locationName}');
  try {
    if (_authLogin == null) {
      print('LocationController: Auth login is null, cannot save location');
      throw Exception('Authentication not initialized');
    }

    // Validate required fields
    if (location.locationName?.isEmpty ?? true) {
      throw Exception('Location name is required');
    }
    if (location.locationAddress?.isEmpty ?? true) {
      throw Exception('Location address is required');
    }

    // Ensure non-null values for required fields
    location = Location(
      locationID: location.locationID ?? '', // Empty string for new locations
      locationName: location.locationName ?? '',
      locationCode: location.locationCode ?? '',
      locationAddress: location.locationAddress ?? '',
      locationCity: location.locationCity ?? '',
      locationState: location.locationState ?? '',
      locationCountry: location.locationCountry ?? '',
      postalCode: location.postalCode ?? '',
      isUseForGeoFencing: location.isUseForGeoFencing ?? false,
      longitude: location.longitude ?? 0.0,
      latitude: location.latitude ?? 0.0,
      distance: location.distance ?? 0.0,
      errorMessage: location.errorMessage ?? '',
      isErrorFound: location.isErrorFound ?? false,
    );

    isLoading.value = true;
    MTAResult result = MTAResult();

    TALocation apiLocation = TALocation()
      ..LocationID = location.locationID ?? ''
      ..LocationName = location.locationName ?? ''
      ..LocationCode = location.locationCode ?? ''
      ..Address = location.locationAddress ?? ''
      ..City = location.locationCity ?? ''
      ..State = location.locationState ?? ''
      ..Country = location.locationCountry ?? ''
      ..PostalCode = location.postalCode ?? ''
      ..IsUseForGeoFencing = location.isUseForGeoFencing ?? false
      ..Latitude = location.latitude ?? 0.0
      ..Longitude = location.longitude ?? 0.0
      ..Distance = location.distance ?? 0.0
      ..ErrorMessage = location.errorMessage ?? ''
      ..IsErrorFound = location.isErrorFound ?? false;

    print('LocationController: Mapped location to API model');
    bool success;
    if (location.locationID?.isEmpty ?? true) {
      print('LocationController: Creating new location');
      success = await TALocationDetails().Save(_authLogin!, apiLocation, result);
    } else {
      print('LocationController: Updating existing location');
      success = await TALocationDetails().Update(_authLogin!, apiLocation, result);
    }

    print('LocationController: Save/Update operation ${success ? 'successful' : 'failed'}');
    if (success) {
      MTAToast().ShowToast(result.ResultMessage);
      await fetchLocation();
    } else {
      print('LocationController: Operation failed - ${result.ErrorMessage}');
      MTAToast().ShowToast(result.ResultMessage);
      throw Exception(result.ErrorMessage);
    }
  } catch (e) {
    print('LocationController: Error in saveLocation: $e');
    MTAToast().ShowToast(e.toString());
    rethrow; // Rethrow to handle in UI if needed
  } finally {
    isLoading.value = false;
  }
}

  Future<void> deleteLocation(String locationId) async {
    print('LocationController: Deleting location with ID: $locationId');
    try {
      if (_authLogin == null) {
        print('LocationController: Auth login is null, cannot delete location');
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      print('LocationController: Calling delete API');
      bool success =
          await TALocationDetails().Delete(_authLogin!, locationId, result);

      print('LocationController: Delete operation ${success ? 'successful' : 'failed'}');
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchLocation();
      } else {
        print('LocationController: Delete failed - ${result.ErrorMessage}');
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      print('LocationController: Error in deleteLocation: $e');
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    print('LocationController: Updating search query to: $query');
    searchQuery.value = query;
    if (query.isEmpty) {
      print('LocationController: Empty query, showing all locations');
      filteredLocations.assignAll(locations);
    } else {
      print('LocationController: Filtering locations');
      filteredLocations.assignAll(
        locations.where((location) {
          bool matches = (location.locationName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (location.locationAddress?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (location.locationCity?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (location.locationState?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (location.locationCountry?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
             (location.postalCode?.toLowerCase().contains(query.toLowerCase()) ?? false);
          print('LocationController: Location ${location.locationName} matches filter: $matches');
          return matches;
        }).toList(),
      );
    }
    print('LocationController: Filtered locations count: ${filteredLocations.length}');
  }

  void sortLocations(String columnName, bool? ascending) {
    print('LocationController: Sorting by column: $columnName, ascending: $ascending');
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;
    print('LocationController: Sort direction: ${isSortAscending.value ? 'ascending' : 'descending'}');

    filteredLocations.sort((a, b) {
      int comparison;
      print('LocationController: Comparing locations');
      switch (columnName) {
        case 'Location Name':
          comparison = a.locationName?.compareTo(b.locationName ?? '') ?? 0;
          break;
        case 'Location Code':
          comparison = a.locationCode?.compareTo(b.locationCode ?? '') ?? 0;
          break;
        case 'Address':
          comparison = a.locationAddress?.compareTo(b.locationAddress ?? '') ?? 0;
          break;
        case 'City':
          comparison = a.locationCity?.compareTo(b.locationCity ?? '') ?? 0;
          break;
        case 'State':
          comparison = a.locationState?.compareTo(b.locationState ?? '') ?? 0;
          break;
        case 'Country':
          comparison = a.locationCountry?.compareTo(b.locationCountry ?? '') ?? 0;
          break;
        default:
          print('LocationController: Unknown sort column: $columnName');
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
    print('LocationController: Sorting complete');
  }
}