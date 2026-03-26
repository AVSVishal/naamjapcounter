import 'package:flutter/foundation.dart';
import '../models/shop_item.dart';
import '../data/items_data.dart';
import '../utils/currency_formatter.dart';

class GameProvider extends ChangeNotifier {
  Country _country = Country.india;
  int _budget = 0;
  int _balance = 0;
  int _currentIndex = 0;
  List<ShopItem> _items = [];
  String _lastMessage = '';

  Country get country => _country;
  int get budget => _budget;
  int get balance => _balance;
  int get currentIndex => _currentIndex;
  List<ShopItem> get items => _items;
  String get lastMessage => _lastMessage;
  bool get isIndia => _country.isIndia;
  int get totalItems => _items.length;

  ShopItem get currentItem => _items[_currentIndex];

  String get formattedBalance => CurrencyFormatter.format(
        _balance,
        indian: isIndia,
        symbol: _country.currencySymbol,
      );

  String get formattedBudget => CurrencyFormatter.format(
        _budget,
        indian: isIndia,
        symbol: _country.currencySymbol,
      );

  int get totalSpent => _budget - _balance;

  String get formattedSpent => CurrencyFormatter.format(
        totalSpent,
        indian: isIndia,
        symbol: _country.currencySymbol,
      );

  String formatPrice(int price) => CurrencyFormatter.format(
        price,
        indian: isIndia,
        symbol: _country.currencySymbol,
      );

  int currentItemPrice() => currentItem.price(isIndia);

  void setCountry(Country country) {
    _country = country;
    notifyListeners();
  }

  void startGame(int budgetAmount) {
    _budget = budgetAmount;
    _balance = budgetAmount;
    _currentIndex = 0;
    _lastMessage = '';
    _items = masterItems
        .where((item) => item.price(_country.isIndia) <= budgetAmount)
        .map((item) => item.copyFresh())
        .toList();
    _items.shuffle();
    notifyListeners();
  }

  void nextItem() {
    if (_currentIndex < _items.length - 1) {
      _currentIndex++;
      _lastMessage = '';
      notifyListeners();
    }
  }

  void prevItem() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _lastMessage = '';
      notifyListeners();
    }
  }

  void goToItem(int index) {
    if (index >= 0 && index < _items.length) {
      _currentIndex = index;
      _lastMessage = '';
      notifyListeners();
    }
  }

  bool buyItem(int quantity) {
    if (quantity <= 0) {
      _lastMessage = 'Enter a valid quantity';
      notifyListeners();
      return false;
    }

    if (quantity > 999999999) {
      _lastMessage = 'Quantity too large';
      notifyListeners();
      return false;
    }

    final price = currentItemPrice();
    final totalCost = quantity * price;

    if (totalCost > _balance) {
      _lastMessage = 'Not enough balance!';
      notifyListeners();
      return false;
    }

    _balance -= totalCost;
    _items[_currentIndex].owned += quantity;
    _lastMessage = 'Bought $quantity ${currentItem.name}(s)';
    notifyListeners();
    return true;
  }

  bool sellItem(int quantity) {
    if (quantity <= 0) {
      _lastMessage = 'Enter a valid quantity';
      notifyListeners();
      return false;
    }

    if (quantity > _items[_currentIndex].owned) {
      _lastMessage = 'You only own ${_items[_currentIndex].owned}!';
      notifyListeners();
      return false;
    }

    final price = currentItemPrice();
    final totalRefund = quantity * price;

    _balance += totalRefund;
    _items[_currentIndex].owned -= quantity;
    _lastMessage = 'Sold $quantity ${currentItem.name}(s)';
    notifyListeners();
    return true;
  }

  void clearMessage() {
    _lastMessage = '';
    notifyListeners();
  }

  void resetGame() {
    _budget = 0;
    _balance = 0;
    _currentIndex = 0;
    _lastMessage = '';
    _items = [];
    notifyListeners();
  }

  int get purchasedItemCount {
    int count = 0;
    for (final item in _items) {
      if (item.owned > 0) count++;
    }
    return count;
  }

  int get totalPurchasedQuantity {
    int total = 0;
    for (final item in _items) {
      total += item.owned;
    }
    return total;
  }

  double get spentPercentage {
    if (_budget == 0) return 0;
    return (((_budget - _balance) / _budget) * 100);
  }
}
