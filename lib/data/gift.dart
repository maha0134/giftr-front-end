import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//one custom data class per object type
//they could all be in one file but more commonly in their own
class Gift {
  String id = '';
  String name = '';
  int price = 0;
  String? store;
  String? url = '';

  //constructor
  Gift(this.id, this.name, this.price, this.store, this.url);

  //Map<String, dynamic> means we are declaring a Map object
  // with keys that are strings and the values that are dynamic

  //the fromJson constructor method that will convert from GiftMap to our Gift object.
  Gift.fromJson(Map<String, dynamic> giftsMap) {
    id = giftsMap['_id'];
    name = giftsMap['name'];
    price = giftsMap['price'];
    // if (giftsMap['store'] != null) {
    //   store = giftsMap['store']['name'];
    //   url = giftsMap['store']['productURL'];
    // } else {
    //   store = 'N/A';
    //   url = 'N/A';
    // }
    // if (giftsMap['store']['name'] != '' && giftsMap['store']['name'] != null)
    store = giftsMap['store']['name'];
    url = giftsMap['store']['productURL'];
  }
}
