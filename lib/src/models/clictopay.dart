class ClicToPay {
  String orderId;
  String formUrl;

  ClicToPay();

  ClicToPay.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      orderId = jsonMap['orderId'].toString();
      formUrl = jsonMap['formUrl'];
    } catch (e) {}
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'formUrl': formUrl,
    };
  }
}
