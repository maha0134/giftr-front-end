import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/http_helper.dart';
import '../utils/snackbar.dart';

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class AddPersonScreen extends StatefulWidget {
  AddPersonScreen({
    Key? key,
    required this.logout,
    required this.nav,
    required this.prefs,
    required this.personID,
    this.personName,
    this.personDOB,
  }) : super(key: key);

  Function nav;
  Function logout;
  var prefs;
  String? personName; // could be empty string
  String personID; //could be zero
  DateTime? personDOB;

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();

  //create global ref key for the form
  final _formKey = GlobalKey<FormState>();

  //state value for user login
  Map<String, dynamic> person = {'name': '', 'birthDate': null};

  @override
  void initState() {
    () async {
      super.initState();
      var token = await widget.prefs.getString('JWT');
      if (token == null) {
        widget.logout('logout');
      }
      person['name'] = widget.personName;
      if (widget.personName == '' || widget.personName == null) {
        person['birthDate'] = null;
      } else {
        person['birthDate'] = widget.personDOB;
        nameController.text = person['name'];
        dobController.text = DateFormat.yMMMd().format(person['birthDate']);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    bool noPerson =
        widget.personName == null || widget.personName == '' ? true : false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.nav('people');
          },
        ),
        title: noPerson
            ? const Text('Add-Person')
            : Text('Edit - ${widget.personName}'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildName(),
            const SizedBox(height: 30),
            _buildDOB(),
            const SizedBox(height: 20),
            ElevatedButton(
                child: noPerson ? const Text('Save') : const Text('Update'),
                onPressed: () async {
                  //use the API to save the new person
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    noPerson ? _createPerson() : _editPerson();
                  }
                }),
          ]),
        ),
      )),
    );
  }

  InputDecoration _styleField(String label, String hint, bool pickDate) {
    return InputDecoration(
      labelText: label, // label
      hintText: hint, //placeholder
      suffixIcon: pickDate
          ? IconButton(
              color: Theme.of(context).iconTheme.color,
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                _showDatePicker();
              },
            )
          : null,
    );
  }

  TextFormField _buildName() {
    return TextFormField(
      decoration: _styleField('Person Name', 'Person Name', false),
      controller: nameController,
      obscureText: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      style: Theme.of(context).textTheme.button,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the name value in the state variable
        setState(() {
          person['name'] = value;
        });
      },
    );
  }

  void _showDatePicker() {
    // bool noPerson = person['birthDate']==null ? true:false;
    // DateTime initDate = noPerson ? person['birthDate'] : DateTime.now();
    showDatePicker(
      context: context,
      initialDate:person['birthDate']==null ? DateTime.now():(person['birthDate']),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then(
      (value) {
        setState(
          () {
            person['birthDate'] = value;
            dobController.text = DateFormat.yMMMd().format(person['birthDate']);
          },
        );
      },
    );
  }

  TextFormField _buildDOB() {
    return TextFormField(
      decoration: _styleField('Date of Birth', 'yyyy-mm-dd', true),
      controller: dobController,
      obscureText: false,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.next,
      style: Theme.of(context).textTheme.button,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid date';
          //becomes the new errorText value
        }
        return null; //means all is good
      },
      onSaved: (String? value) {
        //save the email value in the state variable
        setState(() {
          person['birthDate'] = value;
        });
      },
    );
  }

  void _createPerson() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> personData = {
      'data': {'attributes': person}
    };
    try {
      bool personCreated = await helper.createPerson(widget.prefs, personData);
      if (personCreated) {
        widget.nav('people');
      }
    }
    // catch the error and display it to the user in a snack bar.
    catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }

  void _editPerson() async {
    HttpHelper helper = HttpHelper();
    Map<String, dynamic> personData = {
      'data': {'attributes': person}
    };
    try {
      bool personUpdated =
          await helper.updatePerson(widget.prefs, personData, widget.personID);
      if (personUpdated) {
        widget.nav('people');
      }
    }
    // catch the error and display it to the user in a snack bar.
    catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }
}
