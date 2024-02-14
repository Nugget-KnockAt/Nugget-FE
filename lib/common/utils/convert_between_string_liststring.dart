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

List<Map<String, dynamic>> parseMultipleJson(String jsonString) {
  List<Map<String, dynamic>> jsonObjects = [];

  // 정규 표현식을 사용하여 JSON 객체를 분리합니다.
  RegExp regExp = RegExp(r'\{.*?\}(?=\s*\{)|\{.*?\}\s*$');
  var matches = regExp.allMatches(jsonString);

  for (var match in matches) {
    try {
      String matchedString = match.group(0) ?? '';
      Map<String, dynamic> jsonObject = json.decode(matchedString);
      jsonObjects.add(jsonObject);
    } catch (e) {
      print('JSON 파싱 에러: $e');
    }
  }

  return jsonObjects;
}
