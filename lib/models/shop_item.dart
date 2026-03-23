import 'package:flutter/material.dart';

class ShopItem {
  final String name;
  final int priceUSD;
  final int priceINR;
  final IconData icon;
  final Color iconColor;
  int owned;

  ShopItem({
    required this.name,
    required this.priceUSD,
    required this.priceINR,
    required this.icon,
    required this.iconColor,
    this.owned = 0,
  });

  int price(bool isIndia) => isIndia ? priceINR : priceUSD;

  ShopItem copyFresh() => ShopItem(
        name: name,
        priceUSD: priceUSD,
        priceINR: priceINR,
        icon: icon,
        iconColor: iconColor,
        owned: 0,
      );
}

enum Country {
  india('India', '\u20B9', '\u{1F1EE}\u{1F1F3}'),
  us('United States', '\$', '\u{1F1FA}\u{1F1F8}');

  final String label;
  final String currencySymbol;
  final String flag;

  const Country(this.label, this.currencySymbol, this.flag);

  bool get isIndia => this == Country.india;
}

class BudgetOption {
  final String label;
  final int amount;
  final String subtitle;

  const BudgetOption({
    required this.label,
    required this.amount,
    this.subtitle = '',
  });
}
