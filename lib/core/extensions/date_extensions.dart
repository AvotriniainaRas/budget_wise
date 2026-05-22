extension DateExtension on DateTime {
  String toReadable() {
    return '${day.toString().padLeft(2, '0')}/'
        '${month.toString().padLeft(2, '0')}/'
        '$year';
  }

  String toFileName() {
    return '${year}_${month.toString().padLeft(2, '0')}'
        '_${day.toString().padLeft(2, '0')}';
  }
}