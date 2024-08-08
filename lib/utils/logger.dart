import 'package:logger/logger.dart';
import 'dart:developer' as dev;

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // 表示されるコールスタックの数
    errorMethodCount: 5, // 表示されるスタックトレースのコールスタックの数
    lineLength: 80, // 区切りラインの長さ
  ),
);

class CrashlyticsOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // log出します。
    for (final e in event.lines) {
      dev.log(e, name: 'logger');
    }
  }
}

extension LevelExt on Level {
  bool isSerious(Level level) {
    return value >= level.value;
  }
}
