import 'dart:math' as math;

/// Prayer time calculator using the Muslim World League (MWL) method.
/// Fajr: −18°  |  Isha: −17°  |  Asr: Shafi'i (shadow factor = 1)
class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  static PrayerTimes calculate({
    required double lat,
    required double lon,
    required DateTime date,
    double fajrAngle = 18.0,
    double ishaAngle = 17.0,
  }) {
    final jd = _julianDate(date.year, date.month, date.day);
    final d = jd - 2451545.0;

    // Sun position
    final g = _fix(357.529 + 0.98560028 * d); // mean anomaly
    final q = _fix(280.459 + 0.98564736 * d); // mean longitude
    final L = _fix(q + 1.915 * _dsin(g) + 0.02 * _dsin(2 * g)); // ecliptic lon
    final e = 23.439 - 0.00000036 * d; // obliquity

    // Right ascension (hours) and declination (degrees)
    final raDeg = _fix(_deg(math.atan2(_dcos(e) * _dsin(L), _dcos(L))));
    final decl  = _deg(math.asin(_dsin(e) * _dsin(L)));
    final eqt   = q / 15.0 - raDeg / 15.0; // equation of time (hours)

    // Dhuhr in local clock time
    final tzH    = date.timeZoneOffset.inSeconds / 3600.0;
    final dhuhrH = 12.0 - lon / 15.0 - eqt + tzH;

    // Hour angle for sun at given altitude (degrees above horizon, negative = below)
    double ha(double alt) {
      final cosHA = (_dsin(alt) - _dsin(lat) * _dsin(decl)) /
          (_dcos(lat) * _dcos(decl));
      if (cosHA.abs() > 1) return double.nan;
      return _deg(math.acos(cosHA)) / 15.0;
    }

    // Asr Shafi'i: shadow = 1× height
    final asrAlt = _deg(math.atan(1.0 / (1.0 + math.tan(_rad((lat - decl).abs())))));

    final ssHA = ha(-0.833); // sunrise / sunset

    DateTime toLocal(double h) {
      if (!h.isFinite) return date;
      h = h % 24;
      if (h < 0) h += 24;
      final mins = (h * 60).round();
      return DateTime(date.year, date.month, date.day, (mins ~/ 60) % 24, mins % 60);
    }

    return PrayerTimes(
      fajr:    toLocal(dhuhrH - ha(-fajrAngle)),
      sunrise: toLocal(dhuhrH - ssHA),
      dhuhr:   toLocal(dhuhrH),
      asr:     toLocal(dhuhrH + ha(asrAlt)),
      maghrib: toLocal(dhuhrH + ssHA),
      isha:    toLocal(dhuhrH + ha(-ishaAngle)),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────
  static double _julianDate(int y, int m, int d) {
    if (m <= 2) { y--; m += 12; }
    final a = y ~/ 100;
    final b = 2 - a + a ~/ 4;
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }

  static double _fix(double a) => a - 360.0 * (a / 360.0).floor();
  static double _dsin(double d) => math.sin(d * math.pi / 180);
  static double _dcos(double d) => math.cos(d * math.pi / 180);
  static double _deg(double r)  => r * 180 / math.pi;
  static double _rad(double d)  => d * math.pi / 180;

  // ── Next prayer helpers ───────────────────────────────────────
  static const _names = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  String nextPrayerKey(DateTime now) {
    final times = [fajr, dhuhr, asr, maghrib, isha];
    for (int i = 0; i < times.length; i++) {
      if (now.isBefore(times[i])) return _names[i];
    }
    return 'fajr';
  }

  DateTime nextPrayerTime(DateTime now) {
    final times = [fajr, dhuhr, asr, maghrib, isha];
    for (final t in times) {
      if (now.isBefore(t)) return t;
    }
    return fajr.add(const Duration(days: 1));
  }
}
