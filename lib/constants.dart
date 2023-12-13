// ignore_for_file: unnecessary_brace_in_string_interps

class Code {
  static const String main = "*99#";
  static const String reqMoney = "*99*2#";
  static const String getDetail = "*99*4*3#";
  static const String getBalance = "*99*3#";

  // static const int simId = -1;

  static String getTrans(int i) {
    return "*99*6*1*$i#";
  }
}
