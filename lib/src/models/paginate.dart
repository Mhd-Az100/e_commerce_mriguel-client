class Paginate {
  int currentPage;
  int lastPage = 0;
  String nextPageUrl;
  String prevPageUrl;

  Paginate();

  Paginate.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      // Helper.printToConsole(jsonMap);
      currentPage = jsonMap['current_page'];
      lastPage = jsonMap['last_page'];
      nextPageUrl = jsonMap['next_page_url'].toString();
      prevPageUrl = jsonMap['prev_page_url'].toString();
    } catch (e) {}
  }

  Map<String, dynamic> toMap() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
    };
  }
}
