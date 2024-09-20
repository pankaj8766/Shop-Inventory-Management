import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_inventory_management/model/get_all_inventry.dart';

class InventoryController extends GetxController {
  var inventory = GetAllInventory().obs; // Observable inventory data
  var isLoading = true.obs; // Loading state
  var errorMessage = ''.obs; // Error message

  @override
  void onInit() {
    fetchAllItems(); 
    super.onInit();
  }

  // Fetch all items
  Future<void> fetchAllItems() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('http://localhost:5000/inventory/getAll'));

      if (response.statusCode == 200) {
        inventory.value = getAllInventoryFromJson(response.body); // Parse JSON
      } else {
        errorMessage.value = 'Failed to load inventory';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading(false);
    }
  }

  // Add a new item
  Future<void> addItem(String name, int price, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/inventory/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'price': price, 'quantity': quantity}),
      );

      if (response.statusCode == 201) {
        fetchAllItems(); // Refresh the inventory after adding
      } else {
        errorMessage.value = 'Failed to add item';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }
  }

  // Update stock
  Future<void> updateStock(String id, int qtyChange) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/inventory/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'qtyChange': qtyChange}),
      );

      if (response.statusCode == 200) {
        fetchAllItems(); // Refresh the inventory after updating
      } else {
        errorMessage.value = 'Failed to update stock';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }
  }

  // Get low stock items
  Future<List<Item>> fetchLowStockItems(int threshold) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/inventory/low-stock/$threshold'));

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .map((item) => Item.fromJson(item))
            .toList();
      } else {
        errorMessage.value = 'Failed to load low stock items';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }
    return [];
  }

  // Get total inventory value
  Future<int> fetchTotalInventoryValue() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/inventory/total-value'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['totalValue'];
      } else {
        errorMessage.value = 'Failed to load total value';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    }
    return 0;
  }
}
