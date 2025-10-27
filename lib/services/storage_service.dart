import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _kStreak = 'daily_streak';
  static const _kLastPlayed = 'last_played_iso';
  static const _kTotalPlays = 'total_plays';
  static const _kCorrect = 'correct';

  Future<Map<String, int>> readStats() async {
    final sp = await SharedPreferences.getInstance();
    return {
      'streak': sp.getInt(_kStreak) ?? 0,
      'totalPlays': sp.getInt(_kTotalPlays) ?? 0,
      'correct': sp.getInt(_kCorrect) ?? 0,
    };
  }

  Future<void> bumpPlay({required bool correct}) async {
    final sp = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastIso = sp.getString(_kLastPlayed);
    int streak = sp.getInt(_kStreak) ?? 0;

    if (lastIso != null) {
      final last = DateTime.tryParse(lastIso);
      if (last != null) {
        final diff = DateTime(
          today.year,
          today.month,
          today.day,
        ).difference(DateTime(last.year, last.month, last.day)).inDays;
        if (diff == 1)
          streak += 1;
        else if (diff > 1)
          streak = 1;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await sp.setString(_kLastPlayed, today.toIso8601String());
    await sp.setInt(_kStreak, streak);
    await sp.setInt(_kTotalPlays, (sp.getInt(_kTotalPlays) ?? 0) + 1);
    if (correct) await sp.setInt(_kCorrect, (sp.getInt(_kCorrect) ?? 0) + 1);
  }
}
