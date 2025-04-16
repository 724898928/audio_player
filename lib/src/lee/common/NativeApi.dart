import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path_provider/path_provider.dart';

// 定义 Rust 函数的签名
typedef AddNumbersFunc = Int32 Function(Int32, Int32);
typedef GreetFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef FreeStringFunc = Void Function(Pointer<Utf8>);

class NativeApi {
  static DynamicLibrary? _library;

  static DynamicLibrary get library {
    if (_library == null) {
      _library = _loadLibrary();
    }
    return _library!;
  }

  static DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('librust_lib_audio_player.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.process();
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('rust_lib_audio_player.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('librust_lib_audio_player.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('librust_lib_audio_player.so');
    }
    throw UnsupportedError('Platform not supported');
  }

  // 加载函数
  static int addNumbers(int a, int b) {
    final func = library
        .lookupFunction<AddNumbersFunc, int Function(int, int)>('add_numbers');
    return func(a, b);
  }

  static String greet(String name) {
    final func = library.lookupFunction<GreetFunc,
        Pointer<Utf8> Function(Pointer<Utf8>)>('greet');
    final namePtr = name.toNativeUtf8();
    final resultPtr = func(namePtr);
    final result = resultPtr.toDartString();
    freeString(resultPtr.cast());
    calloc.free(namePtr);
    return result;
  }

  static void freeString(Pointer<Utf8> ptr) {
    final func =
        library.lookupFunction<FreeStringFunc, void Function(Pointer<Utf8>)>(
            'free_string');
    func(ptr);
  }
}
