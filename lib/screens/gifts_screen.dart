import 'package:flutter/material.dart';
import 'package:GIFTR/data/http_helper.dart';
import 'package:intl/intl.dart';
import '../data/http_helper.dart';
import '../data/gift.dart';
import 'dart:async';

import '../utils/snackbar.dart';
//get person by id

enum Screen { LOGIN, PEOPLE, GIFTS, ADDGIFT, ADDPERSON }

class GiftsScreen extends StatefulWidget {
  GiftsScreen({
    Key? key,
    required this.prefs,
    required this.personName,
    required this.personId,
    required this.nav,
    required this.logout,
  }) : super(key: key);

  Function(String) logout;
  var prefs;
  String personName;
  String personId;
  Function nav;

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  List<Gift> futureGifts = [];
  List<Gift> gifts = [];
  bool giftsRetrieved = true;
  bool isOwner = true;
  Map owner = {};

  @override
  void initState() {
    () async {
      super.initState();
      var token = await widget.prefs.getString('JWT');
      if (token == null) {
        widget.logout('logout');
      } else {
        futureGifts = await _getGifts();
        setState(() {
          giftsRetrieved = futureGifts.isNotEmpty;
          gifts = futureGifts;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //back to the people page using the function from main.dart
            widget.nav('people', widget.personId, widget.personName, null);
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //logout and return to login screen
              widget.logout('logout');
            },
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: giftsRetrieved
              ? _giftListBuilder()
              : Text(
                  'There are no gift ideas yet for ${widget.personName}',
                  style: Theme.of(context).textTheme.bodyText2,
                )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //go to the add gift page
          widget.nav('add_gift', widget.personId, widget.personName, null);
        },
      ),
    );
  }


  ListView _giftListBuilder() {
    return ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(gifts[index].name),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${NumberFormat.simpleCurrency(locale: 'en_CA', decimalDigits: 2).format(gifts[index].price)}'),
                  if(!(gifts[index].store == null || gifts[index].store!.isEmpty)) ...[
                    Text('${gifts[index].store}')
                  ],
                  if(!(gifts[index].url == null || gifts[index].url!.isEmpty)) ...[
                    Text('${gifts[index].url}')
                  ]
                ]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Gift currentGift = gifts[index];
                      widget.nav('add_gift', widget.personId, widget.personName,
                          currentGift);
                    }),
                Visibility(
                  visible: isOwner,
                  child: IconButton(
                  icon: Icon(Icons.delete,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  onPressed: () async {
                    await showDialog<Future<bool>>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        title: Text(
                          'Delete Confirmation',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        content: Text(
                          'Are you sure that you want to delete this gift?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, Future(() => true));
                              _deleteGift(widget.personId, index);
                            },
                            child: Text(
                              'Yes',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, Future(() => false)),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                  )
              ],
            ),
          ));
        });
  }

  Future<List<Gift>> _getGifts() async {
    HttpHelper helper = HttpHelper();
    try {
      Map responseBody =
          await helper.getPersonFromId(widget.prefs, widget.personId);
      List retrievedGifts = responseBody['data']['attributes']['gifts'];
      
      if (retrievedGifts.isNotEmpty) {
        futureGifts = retrievedGifts.map<Gift>((element) {
          Gift gift = Gift.fromJson(element);
          return gift;
        }).toList();
      }
      //checking for owner to enable deletion of gifts
      String ownerId = responseBody['data']['attributes']['owner'];
      Map userId = await _checkOwner();
      if (userId['data']['id'] != ownerId) {
        // setState(() {
        isOwner = false;
        // });
      }
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
    return futureGifts;
  }

  Future _deleteGift(String personId, int index) async {
    HttpHelper helper = HttpHelper();
    var giftId = gifts[index].id;
    try {
      bool giftDeleted =
          await helper.deleteGift(widget.prefs, personId, giftId);
      if (giftDeleted) {
        setState(() {
          gifts.removeAt(index);
          if (gifts.isEmpty) {
            giftsRetrieved = false;
          }
        });
      }
    } catch (err) {
      CustomErrorPrompt.snackbar(err, context);
    }
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
  // Widget _showGiftCards(index){
  //   bool giftStore = gifts[index].store != null || gifts[index].store!.isNotEmpty;
  //   bool giftUrl = gifts[index].url != null || gifts[index].url!.isNotEmpty;
  //   return Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Visibility(
  //                 //   visible: giftStore,
  //                 //   maintainSize: false,
  //                 //   maintainAnimation: false,
  //                 //   maintainState: false,
  //                 //   child: Text('${gifts[index].store}'),
  //                 // ),
  //                 if(giftStore) ...[ Text('${gifts[index].store}')],
  //                 Text(
  //                     '${NumberFormat.simpleCurrency(locale: 'en_CA', decimalDigits: 2).format(gifts[index].price)}'),
  //                 Visibility(
  //                   visible:giftUrl,
  //                   maintainSize: false,
  //                   child: Text('${gifts[index].url}')
  //                 )
  //               ]);
  // }
}