// inventory_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_attendance/model/dataEnetry/inventary_model.dart';
// import 'package:time_attendance/model/master_tab_model/inventory_model.dart';

class InventoryController extends GetxController {
  final isLoading = false.obs;
  final inventories = <InventoryModel>[].obs;
  final filteredInventories = <InventoryModel>[].obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final isSortAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInventories();
  }

  Future<void> fetchInventories() async {
    try {
      isLoading.value = true;
      
      // Simulating API call or data fetching
      inventories.value = [
        InventoryModel(
          inventoryId: '1',
          name: 'John Doe',
          laptop: 'HP Pavilion',
          laptopCharger: 'Original HP Charger',
          mobile: 'iPhone 12',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'john.doe@company.com',
          recordUpdateOn: '2024-03-27',
          bySenior: 'Admin',
          byUserLogin: 'johndoe',
        ),
        InventoryModel(
          inventoryId: '2',
          name: 'Jane Smith',
          laptop: 'Dell XPS',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung S21',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'jane.smith@company.com',
          recordUpdateOn: '2024-03-26',
          bySenior: 'Manager',
          byUserLogin: 'janesmith',
        ),
        InventoryModel(
          inventoryId: '3',
          name: 'Mike Johnson',
          laptop: 'Lenovo ThinkPad',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus 9',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'mike.j@company.com',
          recordUpdateOn: '2024-03-25',
          bySenior: 'Team Lead',
          byUserLogin: 'mikej',
        ),
        InventoryModel(
          inventoryId: '4',
          name: 'Sarah Wilson',
          laptop: 'MacBook Pro',
          laptopCharger: 'Apple Charger',
          mobile: 'iPhone 13',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'sarah.w@company.com',
          recordUpdateOn: '2024-03-24',
          bySenior: 'Supervisor',
          byUserLogin: 'sarahw',
        ),
        InventoryModel(
          inventoryId: '5',
          name: 'Robert Brown',
          laptop: 'Asus ZenBook',
          laptopCharger: 'Asus Charger',
          mobile: 'Google Pixel 6',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'robert.b@company.com',
          recordUpdateOn: '2024-03-23',
          bySenior: 'Director',
          byUserLogin: 'robertb',
        ),
        InventoryModel(
          inventoryId: '6',
          name: 'Emily Davis',
          laptop: 'HP Spectre',
          laptopCharger: 'HP Charger',
          mobile: 'iPhone 12 Pro',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'emily.d@company.com',
          recordUpdateOn: '2024-03-22',
          bySenior: 'Manager',
          byUserLogin: 'emilyd',
        ),
        InventoryModel(
          inventoryId: '7',
          name: 'David Miller',
          laptop: 'Dell Latitude',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung S22',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'david.m@company.com',
          recordUpdateOn: '2024-03-21',
          bySenior: 'Team Lead',
          byUserLogin: 'davidm',
        ),
        InventoryModel(
          inventoryId: '8',
          name: 'Lisa Anderson',
          laptop: 'Lenovo Yoga',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus 10',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'lisa.a@company.com',
          recordUpdateOn: '2024-03-20',
          bySenior: 'Supervisor',
          byUserLogin: 'lisaa',
        ),
        InventoryModel(
          inventoryId: '9',
          name: 'James Wilson',
          laptop: 'MacBook Air',
          laptopCharger: 'Apple Charger',
          mobile: 'iPhone 13 Pro',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'james.w@company.com',
          recordUpdateOn: '2024-03-19',
          bySenior: 'Director',
          byUserLogin: 'jamesw',
        ),
        InventoryModel(
          inventoryId: '10',
          name: 'Emma Thompson',
          laptop: 'HP Envy',
          laptopCharger: 'HP Charger',
          mobile: 'Google Pixel 7',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'emma.t@company.com',
          recordUpdateOn: '2024-03-18',
          bySenior: 'Manager',
          byUserLogin: 'emmat',
        ),
        InventoryModel(
          inventoryId: '11',
          name: 'Michael Clark',
          laptop: 'Dell Precision',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung S21 Ultra',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'michael.c@company.com',
          recordUpdateOn: '2024-03-17',
          bySenior: 'Team Lead',
          byUserLogin: 'michaelc',
        ),
        InventoryModel(
          inventoryId: '12',
          name: 'Sophie Turner',
          laptop: 'Lenovo Legion',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus 9 Pro',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'sophie.t@company.com',
          recordUpdateOn: '2024-03-16',
          bySenior: 'Supervisor',
          byUserLogin: 'sophiet',
        ),
        InventoryModel(
          inventoryId: '13',
          name: 'William Harris',
          laptop: 'Asus ROG',
          laptopCharger: 'Asus Charger',
          mobile: 'iPhone 12 Mini',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'william.h@company.com',
          recordUpdateOn: '2024-03-15',
          bySenior: 'Director',
          byUserLogin: 'williamh',
        ),
        InventoryModel(
          inventoryId: '14',
          name: 'Olivia Martin',
          laptop: 'HP ProBook',
          laptopCharger: 'HP Charger',
          mobile: 'Google Pixel 6a',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'olivia.m@company.com',
          recordUpdateOn: '2024-03-14',
          bySenior: 'Manager',
          byUserLogin: 'oliviam',
        ),
        InventoryModel(
          inventoryId: '15',
          name: 'Daniel Lee',
          laptop: 'Dell Inspiron',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung A52',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'daniel.l@company.com',
          recordUpdateOn: '2024-03-13',
          bySenior: 'Team Lead',
          byUserLogin: 'daniell',
        ),
        InventoryModel(
          inventoryId: '16',
          name: 'Isabella White',
          laptop: 'Lenovo IdeaPad',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus Nord',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'isabella.w@company.com',
          recordUpdateOn: '2024-03-12',
          bySenior: 'Supervisor',
          byUserLogin: 'isabella',
        ),
        InventoryModel(
          inventoryId: '17',
          name: 'Alexander King',
          laptop: 'MacBook Pro M1',
          laptopCharger: 'Apple Charger',
          mobile: 'iPhone 13 Mini',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'alex.k@company.com',
          recordUpdateOn: '2024-03-11',
          bySenior: 'Director',
          byUserLogin: 'alexk',
        ),
        InventoryModel(
          inventoryId: '18',
          name: 'Sophia Baker',
          laptop: 'HP EliteBook',
          laptopCharger: 'HP Charger',
          mobile: 'Google Pixel 5',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'sophia.b@company.com',
          recordUpdateOn: '2024-03-10',
          bySenior: 'Manager',
          byUserLogin: 'sophiab',
        ),
        InventoryModel(
          inventoryId: '19',
          name: 'Ethan Wright',
          laptop: 'Dell Vostro',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung S20',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'ethan.w@company.com',
          recordUpdateOn: '2024-03-09',
          bySenior: 'Team Lead',
          byUserLogin: 'ethanw',
        ),
        InventoryModel(
          inventoryId: '20',
          name: 'Ava Scott',
          laptop: 'Lenovo ThinkBook',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus 8T',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'ava.s@company.com',
          recordUpdateOn: '2024-03-08',
          bySenior: 'Supervisor',
          byUserLogin: 'avas',
        ),
        InventoryModel(
          inventoryId: '21',
          name: 'Lucas Green',
          laptop: 'Asus VivoBook',
          laptopCharger: 'Asus Charger',
          mobile: 'iPhone 11',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'lucas.g@company.com',
          recordUpdateOn: '2024-03-07',
          bySenior: 'Director',
          byUserLogin: 'lucasg',
        ),
        InventoryModel(
          inventoryId: '22',
          name: 'Mia Adams',
          laptop: 'HP Pavilion',
          laptopCharger: 'HP Charger',
          mobile: 'Google Pixel 4',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'mia.a@company.com',
          recordUpdateOn: '2024-03-06',
          bySenior: 'Manager',
          byUserLogin: 'miaa',
        ),
        InventoryModel(
          inventoryId: '23',
          name: 'Henry Nelson',
          laptop: 'Dell G15',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung Note 20',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'henry.n@company.com',
          recordUpdateOn: '2024-03-05',
          bySenior: 'Team Lead',
          byUserLogin: 'henryn',
        ),
        InventoryModel(
          inventoryId: '24',
          name: 'Charlotte Hill',
          laptop: 'Lenovo Flex',
          laptopCharger: 'Lenovo Charger',
          mobile: 'OnePlus 8',
          mobileCharger: 'OnePlus Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'charlotte.h@company.com',
          recordUpdateOn: '2024-03-04',
          bySenior: 'Supervisor',
          byUserLogin: 'charlotteh',
        ),
        InventoryModel(
          inventoryId: '25',
          name: 'Sebastian Ross',
          laptop: 'MacBook Air M1',
          laptopCharger: 'Apple Charger',
          mobile: 'iPhone 12 Pro Max',
          mobileCharger: 'Apple Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'sebastian.r@company.com',
          recordUpdateOn: '2024-03-03',
          bySenior: 'Director',
          byUserLogin: 'sebastianr',
        ),
        InventoryModel(
          inventoryId: '26',
          name: 'Amelia Cooper',
          laptop: 'HP ZBook',
          laptopCharger: 'HP Charger',
          mobile: 'Google Pixel 3',
          mobileCharger: 'Google Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'amelia.c@company.com',
          recordUpdateOn: '2024-03-02',
          bySenior: 'Manager',
          byUserLogin: 'ameliac',
        ),
        InventoryModel(
          inventoryId: '27',
          name: 'Jack Morgan',
          laptop: 'Dell XPS 15',
          laptopCharger: 'Dell Charger',
          mobile: 'Samsung A72',
          mobileCharger: 'Samsung Charger',
          idCard: 'Available',
          accessCard: 'Granted',
          emailId: 'jack.m@company.com',
          recordUpdateOn: '2024-03-01',
          bySenior: 'Team Lead',
          byUserLogin: 'jackm',
        ),
          // Add more dummy data as needed
      ];

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      // Handle error
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveInventory(InventoryModel inventory) async {
    try {
      isLoading.value = true;
      
      // Simulating save operation
      if (inventory.inventoryId == null || inventory.inventoryId!.isEmpty) {
        // Add new inventory
        inventory.inventoryId = DateTime.now().millisecondsSinceEpoch.toString();
        inventories.add(inventory);
      } else {
        // Update existing inventory
        final index = inventories.indexWhere((i) => i.inventoryId == inventory.inventoryId);
        if (index != -1) {
          inventories[index] = inventory;
        }
      }

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInventory(String inventoryId) async {
    try {
      isLoading.value = true;
      
      // Simulating delete operation
      inventories.removeWhere((i) => i.inventoryId == inventoryId);
      updateSearchQuery(searchQuery.value);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredInventories.assignAll(inventories);
    } else {
      filteredInventories.assignAll(
        inventories.where((inventory) =>
            (inventory.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (inventory.laptop?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (inventory.mobile?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (inventory.emailId?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ),
      );
    }
  }

  void sortInventories(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredInventories.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Name':
          comparison = (a.name ?? '').compareTo(b.name ?? '');
          break;
        case 'Laptop':
          comparison = (a.laptop ?? '').compareTo(b.laptop ?? '');
          break;
        case 'Mobile':
          comparison = (a.mobile ?? '').compareTo(b.mobile ?? '');
          break;
        case 'Email ID':
          comparison = (a.emailId ?? '').compareTo(b.emailId ?? '');
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}