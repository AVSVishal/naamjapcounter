class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(int amount, {required bool indian, required String symbol}) {
    if (amount < 0) return '-$symbol${format(-amount, indian: indian, symbol: '')}';
    if (indian) {
      return '$symbol${_formatIndian(amount)}';
    }
    return '$symbol${_formatWestern(amount)}';
  }

  static String _formatIndian(int amount) {
    final s = amount.toString();
    if (s.length <= 3) return s;

    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);

    final buffer = StringBuffer();
    for (var i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(rest[i]);
    }

    return '${buffer.toString()},$last3';
  }

  static String _formatWestern(int amount) {
    final s = amount.toString();
    if (s.length <= 3) return s;

    final buffer = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(s[i]);
      count++;
    }

    return buffer.toString().split('').reversed.join();
  }

  static String formatCompact(int amount, {required bool indian}) {
    if (indian) return _formatCompactIndian(amount);
    return _formatCompactWestern(amount);
  }

  static String _formatCompactIndian(int amount) {
    if (amount >= 10000000) {
      final crore = amount / 10000000;
      if (crore == crore.truncateToDouble()) {
        return '${crore.toInt()} Cr';
      }
      return '${crore.toStringAsFixed(1)} Cr';
    }
    if (amount >= 100000) {
      final lakh = amount / 100000;
      if (lakh == lakh.truncateToDouble()) {
        return '${lakh.toInt()} L';
      }
      return '${lakh.toStringAsFixed(1)} L';
    }
    if (amount >= 1000) {
      final k = amount / 1000;
      if (k == k.truncateToDouble()) {
        return '${k.toInt()}K';
      }
      return '${k.toStringAsFixed(1)}K';
    }
    return amount.toString();
  }

  static String _formatCompactWestern(int amount) {
    if (amount >= 1000000000) {
      final b = amount / 1000000000;
      if (b == b.truncateToDouble()) {
        return '${b.toInt()}B';
      }
      return '${b.toStringAsFixed(1)}B';
    }
    if (amount >= 1000000) {
      final m = amount / 1000000;
      if (m == m.truncateToDouble()) {
        return '${m.toInt()}M';
      }
      return '${m.toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      final k = amount / 1000;
      if (k == k.truncateToDouble()) {
        return '${k.toInt()}K';
      }
      return '${k.toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
