import 'package:intl/intl.dart';

/// Parses event dates stored as ISO strings or common manual formats
/// (e.g. `15/4/2026`, `29/1/2026`, `15-04-2026`).
DateTime? parseFlexibleDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;

  final value = raw.trim();

  try {
    return DateTime.parse(value);
  } catch (_) {}

  const patterns = [
    'd/M/yyyy',
    'dd/M/yyyy',
    'd/MM/yyyy',
    'dd/MM/yyyy',
    'd/M/yy',
    'dd/MM/yyyy',
    'd-M-yyyy',
    'dd-MM-yyyy',
    'd-M-yy',
    'dd-M-yyyy',
  ];

  for (final pattern in patterns) {
    try {
      return DateFormat(pattern).parseStrict(value);
    } catch (_) {}
  }

  final slashParts = value.split('/');
  if (slashParts.length == 3) {
    final day = int.tryParse(slashParts[0]);
    final month = int.tryParse(slashParts[1]);
    var year = int.tryParse(slashParts[2]);
    if (day != null && month != null && year != null) {
      if (year < 100) year += 2000;
      return DateTime(year, month, day);
    }
  }

  final dashParts = value.split('-');
  if (dashParts.length == 3) {
    final day = int.tryParse(dashParts[0]);
    final month = int.tryParse(dashParts[1]);
    var year = int.tryParse(dashParts[2]);
    if (day != null && month != null && year != null) {
      if (year < 100) year += 2000;
      return DateTime(year, month, day);
    }
  }

  return null;
}
