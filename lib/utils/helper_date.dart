import 'package:intl/intl.dart';

DateTime parseDate(String date) {
  final formats = [
    DateFormat('dd-MM-yyyy'),
    DateFormat('MMMM d, yyyy'),
  ];

  for (var format in formats) {
    try {
      return format.parse(date);
    } catch (e) {
      // Continue to try the next format
    }
  }
  throw FormatException('Unsupported date format: $date');
}
