import 'dart:math';

String generateUID() {
  String lower = "abcdefghijklmnopqrstuvwxyz";
  String upper = lower.toUpperCase();
  String digits = "0123456789";
  String alphanum = lower + upper + digits;

  String uid = "";

  for (int i = 0; i < 20; i++) {
    uid += alphanum[Random().nextInt(alphanum.length)];
  }

  print(uid);

  return uid;
}

