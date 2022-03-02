import '../models/field.dart';
import 'package:markets/src/helpers/helper.dart';

class Filter {
  bool delivery;
  bool pickup;
  bool open;
  List<Field> fields;

  Filter();

  Filter.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      open = jsonMap['open'] ?? false;
      delivery = jsonMap['delivery'] ?? false;
      fields =
          jsonMap['fields'] != null && (jsonMap['fields'] as List).length > 0
              ? List.from(jsonMap['fields'])
                  .map((element) => Field.fromJSON(element))
                  .toList()
              : [];
    } catch (e) {
      Helper.printToConsole(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['open'] = open;
    map['delivery'] = delivery;
    map['fields'] = fields.map((element) => element.toMap()).toList();
    return map;
  }

  @override
  String toString() {
    String filter = "";
    if (delivery) {
      if (open) {
        filter =
            "search=available_for_delivery:1;closed:0&searchFields=available_for_delivery:=;closed:=&searchJoin=and";
      } else {
        filter =
            "search=available_for_delivery:1&searchFields=available_for_delivery:=";
      }
    } else if (open) {
      filter = "search=closed:${open ? 0 : 1}&searchFields=closed:=";
    }
    return filter;
  }

  Map<String, dynamic> toQuery({Map<String, dynamic> oldQuery}) {
    Map<String, dynamic> query = {};
    String relation = '';
    if (oldQuery != null) {
      relation = oldQuery['with'] != null ? oldQuery['with'] + '.' : '';
      query['with'] = oldQuery['with'] != null ? oldQuery['with'] : null;
      if (oldQuery['paginate'] == true) query['paginate'] = 'true';
      if (oldQuery['sub_cat'] == true) query['sub_cat'] = 'true';
    }
    if (delivery) {
      if (open) {
        query['search'] = relation + 'available_for_delivery:1;closed:0';
        query['searchFields'] = relation + 'available_for_delivery:=;closed:=';
      } else {
        query['search'] = relation + 'available_for_delivery:1';
        query['searchFields'] = relation + 'available_for_delivery:=';
      }
    } else if (open) {
      query['search'] = relation + 'closed:${open ? 0 : 1}';
      query['searchFields'] = relation + 'closed:=';
    }
    if (fields != null && fields.isNotEmpty) {
      Helper.printToConsole(fields.map((element) => element.id).toList());
      query['fields[]'] = fields.map((element) => element.id).toList();
    }
    if (oldQuery != null) {
      if (query['search'] != null) {
        query['search'] += ';' + oldQuery['search'];
      } else {
        query['search'] = oldQuery['search'];
      }

      if (query['searchFields'] != null) {
        query['searchFields'] += ';' + oldQuery['searchFields'];
      } else {
        query['searchFields'] = oldQuery['searchFields'];
      }
      if (query['orderBy'] != null) {
        query['orderBy'] += ';' + oldQuery['orderBy'];
      } else {
        query['orderBy'] = oldQuery['orderBy'];
      }
      if (query['sortedBy'] != null) {
        query['sortedBy'] += ';' + oldQuery['sortedBy'];
      } else {
        query['sortedBy'] = oldQuery['sortedBy'];
      }
      if (query['groupBy'] != null) {
        query['groupBy'] += ';' + oldQuery['groupBy'];
      } else {
        query['groupBy'] = oldQuery['groupBy'];
      }

//      query['search'] =
//          oldQuery['search'] != null ? (query['search']) ?? '' + ';' + oldQuery['search'] : query['search'];
//      query['searchFields'] = oldQuery['searchFields'] != null
//          ? query['searchFields'] ?? '' + ';' + oldQuery['searchFields']
//          : query['searchFields'];
    }
    query['searchJoin'] = 'and';
    if (oldQuery != null)
      query['page'] = oldQuery['page'] != null ? oldQuery['page'] : '1';
    return query;
  }
}
