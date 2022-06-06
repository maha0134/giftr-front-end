// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../data/http_helper.dart';
import '../data/gift.dart';
import '../utils/snackbar.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class AddGiftScreen extends StatefulWidget {
  AddGiftScreen(
      {Key? key,
      required this.nav,
      required this.logout,
      required this.prefs,
      required this.personId,
      required this.personName,
      required this.currentGift})
      : super(key: key);

  Function nav;
  Function logout;
  var prefs;
  String personId;
  String? personName; // could be empty string
  Gift? currentGift;
  // int currentPerson=0; //could be zero

  @override
  State<AddGiftScreen> createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final nameController = TextEditingController();
  final storeNameController = TextEditingController();
  final storeController = TextEditingController();
  final priceController = TextEditingController();
  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();
  bool giftExists = false;
  //state value for user login
  Map<String, dynamic> gift = {
    'name': '',
    'price': 0.00,
    'store': {
      'name': '',
      'productURL': '',
    }
  };
  @override
  void initState() {
    () async {
      super.initState();
      var token = await widget.prefs.getString('JWT');
      if (token == null) {
        widget.logout('logout');
      } else{
      giftExists = widget.currentGift != null ? true : false;
      if (giftExists) {
        nameController.text = widget.currentGift!.name;
        priceController.text = widget.currentGift!.price.toString();
        storeNameController.text = widget.currentGift!.store!;
        storeController.text = widget.currentGift!.url!;
      }
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.nav('gifts');
          },
        ),
        title: giftExists
            ? Text('Edit Gift - ${widget.personName}')
            : Text('Add Gift - ${widget.personName}'),
        centerTitle: true,
      ),
      body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildName(),
                        const SizedBox(height: 20),
                        _buildPrice(),
                        const SizedBox(height: 20),
                        _buildStoreName(),
                        const SizedBox(height: 20),
                        _buildStore(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: giftExists
                              ? const Text('Update')
                              : const Text('Save'),
                          onPressed: () async {
                            //use the API to save the new gift for the person
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              giftExists ? _updateGift() : _createGift();
                              //go to the gifts screen
                            }
                          },
                        ),
                      ],
                    ),
                  ]))));
  }

  InputDecoration _styleField(String label, String hint) {
    if (label == 'Price') {
      return InputDecoration(
        prefixText: '\$ ',
        labelText: label, // label
        hintText: hint, //placeholder
      );
    }
    return InputDecoration(
      labelText: label, // label
      hintText: hint, //placeholder
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Gift Idea', 'Gift Idea'),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a gift name';
        } else if (value.length < 4) {
          return 'Name of the gift is not long enough.';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          gift['name'] = value;
        });
      },
    );
  }

  TextFormField _buildStore() {
    return TextFormField(
      decoration: _styleField('Store URL', 'Store URL'),
      controller: storeController,
      obscureText: false,
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift['store']['productURL'] = value;
        });
      },
    );
  }

  TextFormField _buildStoreName() {
    return TextFormField(
      decoration: _styleField('Store Name', 'Store Name'),
      controller: storeNameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          gift['store']['name'] = value;
        });
      },
    );
  }

  TextFormField _buildPrice() {
    return TextFormField(
      decoration: _styleField('Price', 'Approximate gift price'),
      controller: priceController,
      obscureText: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
          //becomes the new errorText value
        } else if (num.parse(value) < 100) {
          return 'Min price: \$100';
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          if (value != null) {
            gift['price'] = num.parse(value);
          }
        });
      },
    );
  }

  Future _createGift() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> giftData = {
      'data': {'attributes': gift}
    };
    try {
      bool isCreated =
          await helper.createGift(widget.prefs, giftData, widget.personId);
      if (isCreated) {
        widget.nav('gifts');
      }
    }
    // catch the error and display it to the user in a snack bar.
    catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }

  Future _updateGift() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> giftData = {
      'data': {'attributes': gift}
    };
    try {
      bool giftUpdated = await helper.updateGift(
          widget.prefs, giftData, widget.personId, widget.currentGift!.id);
      if (giftUpdated) {
        widget.nav('gifts');
      }
    }
    // catch the error and display it to the user in a snack bar.
    catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }
}
