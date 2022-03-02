class Day {
  String id;
  String name;

  Day();

  Day.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
    } catch (e) {}
  }
}
