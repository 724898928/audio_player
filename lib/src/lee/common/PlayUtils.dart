import 'dart:convert';
import 'dart:io';

import 'package:audio_player/src/lee/common/NativeApi.dart';
import 'package:audio_player/src/lee/common/Utils.dart';

import '../../rust/api/simple.dart';
import '../../rust/music_service.dart';
import 'InteractUtil.dart';

typedef AsyncValueChanged = Future<dynamic> Function(dynamic);

class PlayUtils {
  // 控制是否使用android库
  static bool isChange = true;

  static Future<dynamic> hget(String url) async {
    return await Utils.get(url);
  }

  static Future<dynamic> getPosition({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await getPos().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> playerThread(
      {required List<String> songs,
      required BigInt idx,
      AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await playerThreadRun(songs: songs, idx: idx).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toNext({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await nextSong().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPrevious({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await previousSong().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> setList2Player(
      {required List<String> songs,
      AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("SetPlayList", songs);
    } else {
      return await setPlaylist(songs: songs).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPause({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await pause().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toStop(AsyncValueChanged callback) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await stop().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlay(
      {required int idx, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Play", [idx]);
    } else {
      return await play(idx:  BigInt.from(idx)).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlayMode(
      {required PlayMode mode, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await setPlayMode(mode: mode).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSeek(
      {required double tm, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await seek(tm: tm).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSpeed(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await setSpeed(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toVolume(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await setVolume(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> totalLen() async {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
    } else {
      return await getTotalLen();
    }
  }

  static String songMetadata({required String filePath}) {
    if (Platform.isAndroid && isChange) {
      // InteractUtil.instance.addListener();
      return "";
    } else {
      return getSongMetadata(filePath: filePath);
    }
  }
}
