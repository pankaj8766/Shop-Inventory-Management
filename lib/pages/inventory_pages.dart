import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_inventory_management/controller/inventry_controller.dart';
import 'package:shop_inventory_management/model/get_all_inventry.dart';


class InventoryPage extends StatelessWidget {
  final InventoryController controller = Get.put(InventoryController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final RxBool isAddItemVisible = false.obs; // Observable for toggling the add item form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final items = controller.inventory.value.items ?? [];
        final totalValue = controller.inventory.value.totalValue ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Text(
                'Total Inventory Value: \$${totalValue}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(item.name ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Price: \$${item.price}\nQuantity: ${item.quantity}', style: TextStyle(color: Colors.grey[700])),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          _showUpdateStockDialog(context, item);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              if (isAddItemVisible.value) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final name = nameController.text;
                          final price = int.tryParse(priceController.text) ?? 0;
                          final quantity = int.tryParse(quantityController.text) ?? 0;

                          if (name.isNotEmpty) {
                            controller.addItem(name, price, quantity);
                            nameController.clear();
                            priceController.clear();
                            quantityController.clear();
                            isAddItemVisible.value = false; // Hide input fields after adding
                          }
                        },
                        child: const Text('Add'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink(); // If not visible, take no space
            }),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isAddItemVisible.value = !isAddItemVisible.value; // Toggle visibility
        },
        backgroundColor: Colors.teal,
        child: Icon(isAddItemVisible.value ? Icons.close : Icons.add),
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, Item item) {
    final TextEditingController qtyChangeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Stock for ${item.name}'),
          content: TextField(
            controller: qtyChangeController,
            decoration: const InputDecoration(labelText: 'Quantity Change (positive or negative)'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                int qtyChange = int.tryParse(qtyChangeController.text) ?? 0;
                if (qtyChange != 0) {
                  controller.updateStock(item.id!, qtyChange);
                  Get.back(); // Close the dialog
                }
              },
              child: const Text('Update', style: TextStyle(color: Colors.teal)),
            ),
            TextButton(
              onPressed: () => Get.back(), // Close the dialog
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
