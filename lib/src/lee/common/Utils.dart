import 'dart:async';

class Utils {}

extension DurationX on Duration {
  String toFormattedString() {
    return //'${inHours.toString().padLeft(2, '0')}:'
        '${(inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
