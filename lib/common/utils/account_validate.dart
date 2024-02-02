String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return '이메일을 입력해주세요';
  }
  String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return '유효한 이메일 주소를 입력해주세요';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return '비밀번호를 입력해주세요';
  }
  if (value.length < 8) {
    return '비밀번호는 8자 이상이어야 합니다';
  }
  String pattern = r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return '비밀번호는 영문 소문자와 숫자를 포함해야 합니다';
  }
  return null;
}
