import 'dart:math';

class RandomStringGenerator {
  static const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

  String getRandomString(int length) {
    Random random = Random();
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }
}
