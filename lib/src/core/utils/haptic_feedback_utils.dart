import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class HapticUtils {
  static Future<void> lightImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 10);
    }
  }

  static Future<void> mediumImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 30);
    }
  }

  static Future<void> heavyImpact() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 50);
    }
  }

  static Future<void> selectionClick() async {
    await lightImpact();
  }

  static Future<void> buttonPress() async {
    await mediumImpact();
  }

  static Future<void> cardFlip() async {
    await lightImpact();
  }

  static Future<void> success() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        preset: VibrationPreset.dramaticNotification,
      );
    }
  }

  static Future<void> error() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 200);
    }
  }
}
