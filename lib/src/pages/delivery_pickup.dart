import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markets/src/elements/DeliveryAddressBottomSheetWidget.dart';
import 'package:markets/src/repository/settings_repository.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/Global.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import 'package:markets/src/helpers/helper.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;
  PaymentMethodList list;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  void initState() {
    list = new PaymentMethodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (currentUser.value.apiToken == null) {
            //_con.requestForCurrentLocation(context);
          } else {
            LocationResult result = await showLocationPicker(
              context,
              setting.value.googleMapsKey,
              initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0,
                  deliveryAddress.value?.longitude ?? 0),
              //automaticallyAnimateToCurrentLocation: true,
              //mapStylePath: 'assets/mapStyle.json',
              myLocationButtonEnabled: true,
              //resultCardAlignment: Alignment.bottomCenter,
            );

            // if(widget.disableLocation==true)
            if (![null, 'null'].contains(result?.address)) {
              Address address = Address();
              address.address = result.address;
              address.latitude = result.latLng.latitude;
              address.longitude = result.latLng.longitude;
              DeliveryAddressDialog(
                context: context,
                address: address,
                onChanged: (Address _address) async {
                  _con.addAddressFromDelivery(_address);
                  // Navigator.of(context).pushNamed('/PaymentMethod');
                },
              );
            }
            // _con.addAddress(new Address.fromJSON({
            //   'address': result.address,
            //   'latitude': result.latLng.latitude,
            //   'longitude': result.latLng.longitude,
            //   // 'is_default':true,
            //   // 'description':'#id-${result.latLng.latitude.toStringAsFixed(3)}'
            // }));
            // else
            //   _con.addAddress(new Address.fromJSON({
            //     'address': result.address,
            //     'latitude': result.latLng.latitude,
            //     'longitude': result.latLng.longitude,
            //   }));
            // var bottomSheetController = _con.scaffoldKey.currentState.showBottomSheet(
            //   (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: _con.scaffoldKey,disableLocation: true,),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            //   ),
            // );
            // bottomSheetController.closed.then((value) {
            //   // _con.refreshHome();
            //   _con.listenForAddresses();
            // });
          }
        },
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 10),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //     leading: Icon(
            //       Icons.domain,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     title: Text(
            //       S.of(context).pickup,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.display1,
            //     ),
            //     subtitle: Text(
            //       S.of(context).pickup_your_product_from_the_market,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //   ),
            // ),
            // ListView.separated(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   primary: false,
            //   itemCount: list.pickupList.length,
            //   separatorBuilder: (context, index) {
            //     return SizedBox(height: 10);
            //   },
            //   itemBuilder: (context, index) {
            //     //return PaymentMethodListItemWidget(paymentMethod: list.pickupList.elementAt(index));
            //   },
            // ),
            // _con.carts.isNotEmpty //&& Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)
            //     ?
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).delivery_address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.display1,
                    ),
                    subtitle: Text(
                      S.of(context).confirm_your_delivery_address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.delete,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).for_delete,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .merge(TextStyle(fontSize: 13)),
                    ),
                    // subtitle: Text(
                    //   S.of(context).verify_your_quantity_and_click_checkout,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: Theme.of(context).textTheme.caption,
                    // ),
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return DeliveryAddressesItemWidget(
                      address: _con.addresses[index],
                      onPressed: (Address _address) async {
                        Helper.printToConsole(_address.toMap());
                        deliveryAddress.value = _address;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('select_address_id', _address.id);
                        if (_con.addresses[index].id == null ||
                            _con.addresses[index].id == 'null') {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.addAddress(_address);
                            },
                          );
                        } else if (['null', null]
                            .contains(_con.addresses[index].description)) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        } else
                          // Navigator.of(context).pushNamed('/PaymentMethod');
                          Navigator.pop(context);
                      },
                      onDismissed: (value) =>
                          _con.removeDeliveryAddress(_con.addresses[index]),
                      onLongPress: (Address _address) {
                        DeliveryAddressDialog(
                          context: context,
                          address: _address,
                          onChanged: (Address _address) {
                            _con.updateAddress(_address);
                          },
                        );
                      },
                    );
                  },
                ),
                // DeliveryAddressesItemWidget(
                //   address: _con.deliveryAddress,
                //   onPressed: (Address _address) {
                //     if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null') {
                //       DeliveryAddressDialog(
                //         context: context,
                //         address: _address,
                //         onChanged: (Address _address) {
                //           _con.addAddress(_address);
                //         },
                //       );
                //     } else {
                //       Navigator.of(context).pushNamed('/PaymentMethod');
                //     }
                //   },
                //   onLongPress: (Address _address) {
                //     DeliveryAddressDialog(
                //       context: context,
                //       address: _address,
                //       onChanged: (Address _address) {
                //         _con.updateAddress(_address);
                //       },
                //     );
                //   },
                // )
              ],
            )
            // : SizedBox(
            //     height: 0,
            //   ),
          ],
        ),
      ),
    );
  }
}
