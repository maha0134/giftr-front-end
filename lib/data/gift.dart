import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Gift {
  String id = '';
  String name = '';
  int price = 0;
  String? store;
  String? url = '';

  //constructor
  Gift(this.id, this.name, this.price, this.store, this.url);
  Gift.fromJson(Map<String, dynamic> giftsMap) {
    id = giftsMap['_id'];
    name = giftsMap['name'];
    price = giftsMap['price'];
    store = giftsMap['store']['name'];
    url = giftsMap['store']['productURL'];
  }
}
