import 'dart:convert';
import 'dart:io';

import '../../rust/api/simple.dart';
import '../../rust/music_service.dart';
import 'InteractUtil.dart';

typedef AsyncValueChanged = Future<dynamic> Function(dynamic);

class PlayUtils {
  static Future<dynamic> hget(String url) async {
    print("PlayUtils PlayUtils url: $url");
    var requs;
    if (Platform.isAndroid) {
      print("hget do androidExe ");
      requs = await InteractUtil.instance.androidExe("Search", [{"url": url}]);
    } else {
      print("hget do httpGet ");
      requs = await httpGet(url: url);
    }
    print("hget value :$requs");
    return null != requs ? jsonDecode(requs) : null;
  }

  static Future<dynamic> getPosition({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
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
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await playerThreadRun(songs: songs, idx: idx).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toNext({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await nextSong().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPrevious({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
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
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await setPlaylist(songs: songs).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPause({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await pause().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toStop(AsyncValueChanged callback) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await stop().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlay(
      {required BigInt idx, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await play(idx: idx).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlayMode(
      {required PlayMode mode, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await setPlayMode(mode: mode).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSeek(
      {required double tm, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await seek(tm: tm).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSpeed(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await setSpeed(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toVolume(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await setVolume(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> totalLen() async {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
    } else {
      return await getTotalLen();
    }
  }

  static String songMetadata({required String filePath}) {
    if (Platform.isAndroid) {
      // InteractUtil.instance.addListener();
      return "";
    } else {
      return getSongMetadata(filePath: filePath);
    }
  }
}
