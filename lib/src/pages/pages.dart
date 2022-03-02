import 'package:flutter/material.dart';

import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../models/route_argument.dart';
import '../pages/favorites.dart';
import '../pages/home.dart';
import '../pages/orders.dart';
import 'package:flutter/services.dart';
import '../../generated/i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  String version;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 1;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  String version;

  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage =
              HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage =
              FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(S.current.are_you_sure),
            content: new Text(S.current.do_you_want_to_exit_an_app),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(S.current.no),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text(S.current.yes),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        endDrawer: FilterWidget(onFilter: (filter) {
          Navigator.of(context)
              .pushReplacementNamed('/Pages', arguments: widget.currentTab);
        }),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22.w,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28.w),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.local_mall),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
                title: new Container(height: 5.0.w),
                icon: Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.w),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 40.w,
                          offset: Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 13.w,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: new Icon(Icons.home,
                      color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              title: new Container(height: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}
