String ddMMyyyyToIso(String input) {
  final parts = input.split('/');
  if (parts.length != 3) return input; // formato inesperado
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return input;

  final dt = DateTime(year, month, day);
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
