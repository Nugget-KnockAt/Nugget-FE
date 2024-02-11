import 'dart:convert';

List<String> stringToListString(String? str) {
  if (str == null) {
    return [];
  }
  // JSON 문자열을 List<dynamic>으로 변환
  List<dynamic> dynamicList = json.decode(str);

  // List<dynamic>을 List<String>으로 변환
  List<String> stringList = dynamicList.map((item) => item.toString()).toList();

  return stringList;
}

String listStringToString(List<String> list) {
  return jsonEncode(list);
}
