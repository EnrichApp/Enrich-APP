import 'package:intl/intl.dart';

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

class FormatadorData {
  static String formatarUtcParaLocal(String dataIsoUtc, {String formato = 'dd/MM/yyyy HH:mm'}) {
    try {
      final dataUtc = DateTime.parse(dataIsoUtc);
      final dataLocal = dataUtc.toLocal(); // aqui converte pro fuso local do device
      return DateFormat(formato, 'pt_BR').format(dataLocal);
    } catch (e) {
      return 'Data inválida';
    }
  }
}
