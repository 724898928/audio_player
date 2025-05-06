import 'dart:convert';
import 'dart:io';

import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:audio_player/src/lee/model/Song.dart';

import '../../rust/api/simple.dart';
import '../../rust/music_service.dart';
import 'InteractUtil.dart';

typedef AsyncValueChanged = Future<dynamic> Function(dynamic);

class PlayUtils {
  // 控制是否使用android库
  static bool isChange = true;

  static Future<dynamic> hget(String url) async {
    return jsonDecode(await Utils.get(url));
  }

  static Future<dynamic> getPosition({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance
          .androidExe("GetCurrentInfo", []).then((v) async {
        await callback?.call(v);
      });
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
      return await InteractUtil.instance.androidExe("Next", []);
    } else {
      return await nextSong().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPrevious({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Previous", []);
    } else {
      return await previousSong().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> setList2Player(
      {required List<String> songs, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("SetPlayList", songs);
    } else {
      return await setPlaylist(songs: songs).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> addSongList(
      {required List<String> songs, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("AddSongs", songs);
    } else {
      return await addSongs(songs: songs).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> removeSong(int idx) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("DelSong", [idx]);
    } else {
      return await delSong(idx: BigInt.from(idx));
    }
  }

  static Future<dynamic> toPause({AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Pause", []);
    } else {
      return await pause().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toStop(AsyncValueChanged callback) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Stop", []);
    } else {
      return await stop().listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlay(
      {required int idx, AsyncValueChanged? callback}) async {
    if (idx < 0) idx = 0;
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Play", [idx]);
    } else {
      return await play(idx: BigInt.from(idx)).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toPlayMode(
      {required PlayMode mode, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("PlayMode", [mode.index]);
    } else {
      return await setPlayMode(mode: mode).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSeek(
      {required int tm, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Seek", [tm]);
    } else {
      return await seek(tm: tm.toDouble()).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toSpeed(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Speed", []);
    } else {
      return await setSpeed(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> toVolume(
      {required double s, AsyncValueChanged? callback}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("Volume", []);
    } else {
      return await setVolume(v: s).listen((v) async {
        await callback?.call(v);
      });
    }
  }

  static Future<dynamic> totalLen() async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("TotalLen", []);
    } else {
      return await getTotalLen();
    }
  }

  static Future<String> songMetadata({required String filePath}) async {
    if (Platform.isAndroid && isChange) {
      return await InteractUtil.instance.androidExe("SongMetadata", [filePath]);
    } else {
      return await getSongMetadata(filePath: filePath);
    }
  }
}
