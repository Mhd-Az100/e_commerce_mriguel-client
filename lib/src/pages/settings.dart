import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:markets/src/elements/SearchBarWidget.dart';
import 'package:markets/src/helpers/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/settings_controller.dart';
// import '../elements/CircularLoading_con.dart';
import '../elements/PaymentSettingsDialog.dart';
import '../elements/ProfileSettingsDialog.dart';
// import '../elements/SearchBar_con.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    if(['null',null,''].contains(currentUser.value.phone)){
      Future.delayed(Duration.zero,() {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      S.of(context).profile_settings,
                      style: Theme.of(context).textTheme.body2,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        // new TextFormField(
                        //   style: TextStyle(color: Theme.of(context).hintColor),
                        //   keyboardType: TextInputType.text,
                        //   decoration:
                        //       getInputDecoration(hintText: S.of(context).john_doe, labelText: S.of(context).full_name),
                        //   initialValue: _con.user.name,
                        //   validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                        //   onSaved: (input) => _con.user.name = input,
                        // ),
                        // new TextFormField(
                        //   style: TextStyle(color: Theme.of(context).hintColor),
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration:
                        //       getInputDecoration(hintText: 'johndo@gmail.com', labelText: S.of(context).email_address),
                        //   initialValue: _con.user.email,
                        //   validator: (input) => !input.contains('@') ? S.of(context).not_a_valid_email : null,
                        //   onSaved: (input) => _con.user.email = input,
                        // ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'XXX-XXX-XXX', labelText: S.of(context).phone),
                          initialValue: [null,'null'].contains(currentUser.value.phone) ? null : currentUser.value.phone,
                          validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_phone : null,
                          onSaved: (input) => currentUser.value.phone = input,
                        ),
                        // new TextFormField(
                        //   style: TextStyle(color: Theme.of(context).hintColor),
                        //   keyboardType: TextInputType.text,
                        //   decoration: getInputDecoration(
                        //       hintText: S.of(context).your_address, labelText: S.of(context).address),
                        //   initialValue: _con.user.address,
                        //   // validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_address : null,
                        //   onSaved: (input) => _con.user.address = input,
                        // ),
                        // new TextFormField(
                        //   style: TextStyle(color: Theme.of(context).hintColor),
                        //   keyboardType: TextInputType.text,
                        //   decoration: getInputDecoration(
                        //       hintText: S.of(context).your_biography, labelText: S.of(context).about),
                        //   initialValue: _con.user.bio,
                        //   // validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_biography : null,
                        //   onSaved: (input) => _con.user.bio = input,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context).cancel),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          S.of(context).save,
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
        Flushbar(
              // title:  "Ooops !!",
              message:  S.current.update_phone_number,
              duration:  Duration(seconds: 5),     
              flushbarPosition: FlushbarPosition.TOP,         
            )..show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).settings,
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: currentUser.value.id == null
            ? CircularLoadingWidget(height: 500)
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarWidget(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  currentUser.value.name,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.display2,
                                ),
                                Text(
                                  currentUser.value.email,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          SizedBox(
                              width: 55,
                              height: 55,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(300),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(currentUser.value.image.thumb),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              S.of(context).profile_settings,
                              style: Theme.of(context).textTheme.body2,
                            ),
                            trailing: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              minWidth: 50.0,
                              height: 25.0,
                              child: ProfileSettingsDialog(
                                user: currentUser.value,
                                onChanged: () {
                                  _con.update(currentUser.value); 
                                  setState(() {});
                                  // if(cart && currentUser.value.phone != "null") Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).full_name,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            trailing: Text(
                              currentUser.value.name,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).email,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            trailing: Text(
                              currentUser.value.email,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).phone,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            trailing: Text(
                              currentUser.value.phone,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          // ListTile(
                          //   onTap: () {},
                          //   dense: true,
                          //   title: Text(
                          //     S.of(context).address,
                          //     style: Theme.of(context).textTheme.body1,
                          //   ),
                          //   trailing: Text(
                          //     currentUser.value.address != null ?
                          //     Helper.limitString(currentUser.value.address) : '',
                          //     overflow: TextOverflow.fade,
                          //     softWrap: false,
                          //     style: TextStyle(color: Theme.of(context).focusColor),
                          //   ),
                          // ),
                          // ListTile(
                          //   onTap: () {},
                          //   dense: true,
                          //   title: Text(
                          //     S.of(context).about,
                          //     style: Theme.of(context).textTheme.body1,
                          //   ),
                          //   trailing: Text(
                          //     Helper.limitString(currentUser.value.bio),
                          //     overflow: TextOverflow.fade,
                          //     softWrap: false,
                          //     style: TextStyle(color: Theme.of(context).focusColor),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).primaryColor,
                    //     borderRadius: BorderRadius.circular(6),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Theme.of(context).hintColor.withOpacity(0.15),
                    //           offset: Offset(0, 3),
                    //           blurRadius: 10)
                    //     ],
                    //   ),
                    //   child: ListView(
                    //     shrinkWrap: true,
                    //     primary: false,
                    //     children: <Widget>[
                    //       ListTile(
                    //         leading: Icon(Icons.credit_card),
                    //         title: Text(
                    //           S.of(context).payments_settings,
                    //           style: Theme.of(context).textTheme.body2,
                    //         ),
                    //         trailing: ButtonTheme(
                    //           padding: EdgeInsets.all(0),
                    //           minWidth: 50.0,
                    //           height: 25.0,
                    //           child: PaymentSettingsDialog(
                    //             creditCard: _con.creditCard,
                    //             onChanged: () {
                    //               _con.updateCreditCard(_con.creditCard);
                    //               //setState(() {});
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //       ListTile(
                    //         dense: true,
                    //         title: Text(
                    //           S.of(context).default_credit_card,
                    //           style: Theme.of(context).textTheme.body1,
                    //         ),
                    //         trailing: Text(
                    //           _con.creditCard.number.isNotEmpty
                    //               ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...')
                    //               : '',
                    //           style: TextStyle(color: Theme.of(context).focusColor),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text(
                              S.of(context).app_settings,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Languages');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.translate,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).languages,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ],
                            ),
                            trailing: Text(
                              S.of(context).english,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/DeliveryAddresses');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.place,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).delivery_addresses,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Help');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.help,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).help_support,
                                  style: Theme.of(context).textTheme.body1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      _con.update(currentUser.value);
      // Navigator.pop(context);
    }
  }
}
