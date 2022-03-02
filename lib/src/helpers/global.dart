import 'package:markets/src/models/user.dart';
import 'package:markets/src/models/paginate.dart';

double totalAmount = 0.0;
double couponDiscount = 0.0;
double couponDiscountForDelivery = 0.0;
double couponDiscountValue = 0.0;
double startValue = 0.0;
bool stopClick = false;
bool cart = false;
bool showD = true;
int isAlertboxOpened = 0;
bool glbReview = false;
String deliveryIdG = 'null';
String oldPhone = '';
String appVersion = '';
List<User> listUsers = <User>[];
Paginate productsPaginate = Paginate();
bool isPayOnline = false;
