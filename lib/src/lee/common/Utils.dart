import 'dart:async';

class Utils {}

// class TimerUtils {
//   TimerUtils.iniernal()
//       : posTimer = Timer(Duration.zero, () {
//           callback();
//         });

//   static TimerUtils _singleton = TimerUtils.iniernal();

//   factory TimerUtils() => _singleton;

//   VoidCallback callback = () {};

//   Timer posTimer;

//   void changgeTask(VoidCallback callback) {
//     this.callback = callback;
//   }

//   void runTask() {
//     var posTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       callback();
//     });
//   }
// }

extension DurationX on Duration {
  String toFormattedString() {
    return //'${inHours.toString().padLeft(2, '0')}:'
        '${(inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
