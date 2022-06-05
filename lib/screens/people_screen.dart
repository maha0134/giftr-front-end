import 'package:flutter/material.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../data/http_helper.dart';
import '../data/person.dart';
import '../utils/snackbar.dart';

class PeopleScreen extends StatefulWidget {
  PeopleScreen(
      {Key? key, required this.prefs, required this.nav, required this.logout})
      : super(key: key);
  Function(String) logout;
  var prefs;
  Function nav;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<Person> users = [];
  List<Person> persons = [];
  bool fetchHasResults = true;
  @override
  void initState() {
    () async {
      super.initState();
      var token = await widget.prefs.getString('JWT');
      if (token == null) {
        widget.logout('logout');
      } else {
        users = await _getPersons();
        setState(() {
          fetchHasResults = users.isNotEmpty;
          persons = users;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    //sorts the persons based on birth dates
    persons.sort((a, b) {
      var dateA = a.birthDate;
      var dateB = b.birthDate;
      if (dateA.month > dateB.month) {
        return 1;
      } else if (dateA.month < dateB.month) {
        return -1;
      }
      return dateA.day.compareTo(dateB.day);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('GIFTR - People'),
        centerTitle: true,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              widget.logout('login');
            },
          )
        ],
      ),
      body: fetchHasResults ? _listPersons(context) : _emptyScreen(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //go to the add people page
          DateTime now = DateTime.now();
          widget.nav('add_person', "", "", now);
        },
      ),
    );
  }

  Widget _emptyScreen(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text('Please add people.',
          style: Theme.of(context).textTheme.bodyText2));
  }

  Widget _listPersons(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 5),
      itemCount: persons.length,
      itemBuilder: (context, index) {
        return Dismissible(
            background: Container(
              alignment: Alignment.centerRight,
              child: const Padding(
                child: Icon(Icons.delete_forever),
                padding: EdgeInsets.all(10)
              ),
              color: Theme.of(context).colorScheme.onError
            ),
            key: ValueKey<Person>(persons[index]),
            onDismissed: (DismissDirection direction) async {
              await _deletePerson(persons[index].id, index);
              setState(() {
                persons.removeAt(index);
                //if all people deleted, show the Add people text
                if (persons.isEmpty) {
                  fetchHasResults = false;
                }
              });
            },
            confirmDismiss: (DismissDirection direction) async {
              //if person is not owner..return
              Map ownerId = await _checkOwner();
              if (persons[index].owner != ownerId['data']['id']) {
                return Future(() => false);
              }
              return await showDialog<Future<bool>>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Deletion Confirmation',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  content: Text(
                    'Are you sure that you want to delete ${persons[index].name}?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, Future(() => true));
                      },
                      child: Text(
                        'Yes',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, Future(() => false)),
                      child: Text('Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                    ),
                  ],
                ),
              );
            },
            direction: DismissDirection.endToStart,
            child: ListTile(
              tileColor: _birthdayHasPassed(index)
                  ? Theme.of(context).colorScheme.onTertiary
                  : Theme.of(context).colorScheme.error,
              title: Text(persons[index].name),
              subtitle: Text(DateFormat.MMMd()
                  .format(persons[index].birthDate)
                  .toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary
                    ),
                    onPressed: () {
                      String id = persons[index].id;
                      String name = persons[index].name;
                      DateTime dob = persons[index].birthDate;
                      widget.nav('add_person', id, name, dob);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.card_giftcard,
                      color: Theme.of(context)
                            .colorScheme
                            .onTertiaryContainer
                    ),
                    onPressed: () {
                      String id = persons[index].id;
                      String name = persons[index].name;
                      DateTime dob = persons[index].birthDate;
                      widget.nav('gifts', id, name, dob);
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future<List<Person>> _getPersons() async {
    HttpHelper helper = HttpHelper();
    try {
      List responseBody = await helper.getAllPeople(widget.prefs);
      users = responseBody.map<Person>((element) {
        Person user = Person.fromJson(element['data']);
        return user;
      }).toList();
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
    return users;
  }

  Future<Map> _checkOwner() async {
    HttpHelper helper = HttpHelper();
    Map owner = {};
    try {
      owner = await helper.fetchOwner(widget.prefs);
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
    return owner;
  }

  Future _deletePerson(String id, int index) async {
    HttpHelper helper = HttpHelper();

    try {
      await helper.deletePerson(widget.prefs, id);
      return;
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
  }

  bool _birthdayHasPassed(int index) {
    var birthDate = persons[index].birthDate;
    var today = DateTime.now();

    if (today.month > birthDate.month) {
      return true;
    } else if (today.month < birthDate.month) {
      return false;
    } else {
      if (today.day > birthDate.day) {
        return true;
      } else {
        return false;
      }
    }
  }
}
