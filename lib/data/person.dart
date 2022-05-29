import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './gift.dart';

//one custom data class per object type
//they could all be in one file but more commonly in their own
class Person {
  String id = '';
  String name = '';
  DateTime birthDate = DateTime.now();
  List? sharedWith;
  String? imageUrl;
  List<Gift>? gifts;
  String owner = '';

  //constructor
  Person(this.id, this.name,this.birthDate,this.sharedWith,this.imageUrl,this.gifts,this.owner);

  //the fromJson constructor method that will convert from userMap to our User object.
  Person.fromJson(Map<String, dynamic> personMap) {
    id = personMap['id'];
    name = personMap['attributes']['name'];
    birthDate = DateTime.parse(personMap['attributes']['birthDate']);
    sharedWith = personMap['attributes']['sharedWith'];
    imageUrl = personMap['attributes']['imageUrl'];
    gifts = personMap['attributes']['gifts'];
    owner = personMap['attributes']['owner'];
  }
}
