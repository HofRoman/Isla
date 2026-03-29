import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'prayer_times.dart';

/// Prayer times from Aladhan.com API (free, no auth, high accuracy).
/// Falls back to local MWL calculation if network unavailable.
class PrayerApiService {
  static const _base = 'https://api.aladhan.com/v1/timings';

  /// Fetch today's prayer times for [lat]/[lon].
  /// Method 3 = Muslim World League, school 0 = Shafi'i.
  static Future<PrayerTimes> fetch({
    required double lat,
    required double lon,
    DateTime? date,
  }) async {
    final now = date ?? DateTime.now();
    try {
      final ts = (now.millisecondsSinceEpoch ~/ 1000).toString();
      final uri = Uri.parse(
        '$_base/$ts?latitude=$lat&longitude=$lon&method=3&school=0&timezonestring=auto',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final timings = (json['data'] as Map)['timings'] as Map<String, dynamic>;
        return _parse(timings, now);
      }
    } catch (e) {
      debugPrint('Aladhan API error: $e — falling back to local calc');
    }
    // Fallback: local MWL calculation
    return PrayerTimes.calculate(lat: lat, lon: lon, date: now);
  }

  static PrayerTimes _parse(Map<String, dynamic> t, DateTime date) {
    DateTime todt(String s) {
      final parts = s.split(':');
      return DateTime(date.year, date.month, date.day,
          int.parse(parts[0]), int.parse(parts[1]));
    }

    return PrayerTimes(
      fajr:    todt(t['Fajr']    as String),
      sunrise: todt(t['Sunrise'] as String),
      dhuhr:   todt(t['Dhuhr']   as String),
      asr:     todt(t['Asr']     as String),
      maghrib: todt(t['Maghrib'] as String),
      isha:    todt(t['Isha']    as String),
    );
  }
}
