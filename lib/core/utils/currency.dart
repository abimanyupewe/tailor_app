import 'package:intl/intl.dart';

/// Formats a number as Indonesian rupiah without decimals,
/// e.g. 15000 -> "Rp 15.000".
String formatRupiah(num value) {
  final formatted = NumberFormat.decimalPattern('id_ID').format(value.round());
  return 'Rp $formatted';
}
