import 'category.dart';

class RouteArgument {
  String id;
  String heroTag;
  String marketID;
  Category category;
  dynamic param;

  RouteArgument(
      {this.id, this.heroTag, this.param, this.marketID, this.category});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
