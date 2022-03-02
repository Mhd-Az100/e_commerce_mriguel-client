import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:markets/src/helpers/helper.dart';
import '../../generated/i18n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';
import '../repository/settings_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool disableLocation;

  DeliveryAddressBottomSheetWidget(
      {Key key, this.scaffoldKey, this.disableLocation = false})
      : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() =>
      _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState
    extends StateMVC<DeliveryAddressBottomSheetWidget> {
  DeliveryAddressesController _con;

  _DeliveryAddressBottomSheetWidgetState()
      : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.w,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.w), topLeft: Radius.circular(20.w)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30.w,
              offset: Offset(0, -30.w)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: ListView(
              padding: EdgeInsets.only(
                  top: 20.w, bottom: 15.w, left: 20.w, right: 20.w),
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      setting.value.googleMapsKey,
                      initialCenter: LatLng(
                          deliveryAddress.value?.latitude ?? 0,
                          deliveryAddress.value?.longitude ?? 0),
                      //automaticallyAnimateToCurrentLocation: true,
                      //mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      //resultCardAlignment: Alignment.bottomCenter,
                    );

                    if (widget.disableLocation == true)
                      _con.addAddress(new Address.fromJSON({
                        'address': result.address,
                        'latitude': result.latLng.latitude,
                        'longitude': result.latLng.longitude,
                        // 'is_default':true,
                        // 'description':'#id-${result.latLng.latitude.toStringAsFixed(3)}'
                      }));
                    else
                      _con.addAddress(new Address.fromJSON({
                        'address': result.address,
                        'latitude': result.latLng.latitude,
                        'longitude': result.latLng.longitude,
                      }));
                    Helper.printToConsole("result = $result");
                    // Navigator.of(widget.scaffoldKey.currentContext).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36.w,
                        width: 36.w,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w)),
                            color: Theme.of(context).focusColor),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 22.w,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).add_new_delivery_address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                widget.disableLocation == false
                    ? SizedBox(height: 25.w)
                    : SizedBox(height: 0),
                widget.disableLocation == false
                    ? InkWell(
                        onTap: () {
                          _con
                              .changeDeliveryAddressToCurrentLocation()
                              .then((value) {
                            Navigator.of(widget.scaffoldKey.currentContext)
                                .pop();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 36.w,
                              width: 36.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).accentColor),
                              child: Icon(
                                Icons.my_location,
                                color: Theme.of(context).primaryColor,
                                size: 22.w,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          S.of(context).current_location,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25.w),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 25.w);
                  },
                  itemBuilder: (context, index) {
//                return DeliveryAddressesItemWidget(
//                  address: _con.addresses.elementAt(index),
//                  onPressed: (Address _address) {
//                    _con.chooseDeliveryAddress(_address);
//                  },
//                  onLongPress: (Address _address) {
//                    DeliveryAddressDialog(
//                      context: context,
//                      address: _address,
//                      onChanged: (Address _address) {
//                        _con.updateAddress(_address);
//                      },
//                    );
//                  },
//                  onDismissed: (Address _address) {
//                    _con.removeDeliveryAddress(_address);
//                  },
//                );
                    return InkWell(
                      onTap: () {
                        _con
                            .changeDeliveryAddress(
                                _con.addresses.elementAt(index))
                            .then((value) {
                          Navigator.of(widget.scaffoldKey.currentContext).pop();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 36.w,
                            width: 36.w,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.w)),
                                color: Theme.of(context).focusColor),
                            child: Icon(
                              Icons.place,
                              color: Theme.of(context).primaryColor,
                              size: 22.w,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _con.addresses.elementAt(index).address,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style:
                                            Theme.of(context).textTheme.body1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).focusColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 30.w,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13.w, horizontal: config.App(context).appWidth(42.w)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.w),
                  topLeft: Radius.circular(20.w)),
            ),
            child: Container(
              width: 30.w,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }
}
