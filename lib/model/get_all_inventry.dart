// To parse this JSON data, do
//
//     final getAllInventory = getAllInventoryFromJson(jsonString);

import 'dart:convert';

GetAllInventory getAllInventoryFromJson(String str) => GetAllInventory.fromJson(json.decode(str));

String getAllInventoryToJson(GetAllInventory data) => json.encode(data.toJson());

class GetAllInventory {
    List<Item>? items;
    int? totalValue;

    GetAllInventory({
        this.items,
        this.totalValue,
    });

    factory GetAllInventory.fromJson(Map<String, dynamic> json) => GetAllInventory(
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        totalValue: json["totalValue"],
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "totalValue": totalValue,
    };
}

class Item {
    String? id;
    String? name;
    int? price;
    int? quantity;
    int? v;

    Item({
        this.id,
        this.name,
        this.price,
        this.quantity,
        this.v,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "__v": v,
    };
}
