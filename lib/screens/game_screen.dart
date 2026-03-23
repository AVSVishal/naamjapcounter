import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final _quantityController = TextEditingController();
  final _quantityFocus = FocusNode();
  late AnimationController _balanceAnimController;
  late AnimationController _itemAnimController;
  int _displayedBalance = 0;
  int _previousBalance = 0;
  int _lastItemIndex = 0;

  @override
  void initState() {
    super.initState();
    _balanceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _itemAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final provider = context.read<GameProvider>();
    _displayedBalance = provider.balance;
    _previousBalance = provider.balance;
    _lastItemIndex = provider.currentIndex;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityFocus.dispose();
    _balanceAnimController.dispose();
    _itemAnimController.dispose();
    super.dispose();
  }

  void _animateBalance(int from, int to) {
    _previousBalance = from;
    _balanceAnimController.reset();
    _balanceAnimController.addListener(() {
      setState(() {
        _displayedBalance = (_previousBalance +
                ((_balanceAnimController.value) * (to - _previousBalance)))
            .round();
      });
    });
    _balanceAnimController.forward().then((_) {
      setState(() => _displayedBalance = to);
    });
  }

  void _onBuy() {
    final provider = context.read<GameProvider>();
    final qty = int.tryParse(_quantityController.text) ?? 0;
    final oldBalance = provider.balance;
    if (provider.buyItem(qty)) {
      _quantityController.clear();
      _animateBalance(oldBalance, provider.balance);
      FocusScope.of(context).unfocus();
    } else {
      _showSnack(provider.lastMessage);
    }
  }

  void _onSell() {
    final provider = context.read<GameProvider>();
    final qty = int.tryParse(_quantityController.text) ?? 0;
    final oldBalance = provider.balance;
    if (provider.sellItem(qty)) {
      _quantityController.clear();
      _animateBalance(oldBalance, provider.balance);
      FocusScope.of(context).unfocus();
    } else {
      _showSnack(provider.lastMessage);
    }
  }

  void _showSnack(String msg) {
    if (msg.isEmpty) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _navigateItem(int direction) {
    final provider = context.read<GameProvider>();
    _quantityController.clear();
    FocusScope.of(context).unfocus();
    if (direction > 0) {
      provider.nextItem();
    } else {
      provider.prevItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final item = provider.currentItem;
    final price = item.price(provider.isIndia);
    final formattedPrice = provider.formatPrice(price);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.currentIndex != _lastItemIndex) {
      _lastItemIndex = provider.currentIndex;
      _itemAnimController.reset();
      _itemAnimController.forward();
    }

    if (_displayedBalance != provider.balance &&
        !_balanceAnimController.isAnimating) {
      _displayedBalance = provider.balance;
    }

    final balanceText = CurrencyFormatter.format(
      _displayedBalance,
      indian: provider.isIndia,
      symbol: provider.country.currencySymbol,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitDialog();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _showExitDialog,
                      icon: Icon(
                        Icons.close_rounded,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${provider.currentIndex + 1} / ${provider.totalItems}',
                        style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showReceiptDialog(provider),
                      icon: Icon(
                        Icons.receipt_long_outlined,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < -100) {
                        _navigateItem(1);
                      } else if (details.primaryVelocity! > 100) {
                        _navigateItem(-1);
                      }
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildItemContent(
                      key: ValueKey(provider.currentIndex),
                      item: item,
                      formattedPrice: formattedPrice,
                      isDark: isDark,
                      tt: tt,
                      cs: cs,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed:
                          provider.currentIndex > 0 ? () => _navigateItem(-1) : null,
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        size: 36,
                        color: provider.currentIndex > 0
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: provider.currentIndex < provider.totalItems - 1
                          ? () => _navigateItem(1)
                          : null,
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        size: 36,
                        color: provider.currentIndex < provider.totalItems - 1
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _onSell,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.sellColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Sell',
                            style: tt.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 54,
                        child: TextField(
                          controller: _quantityController,
                          focusNode: _quantityFocus,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: tt.titleMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.3),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white70 : Colors.black,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: isDark ? Colors.white70 : Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _onBuy,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.buyColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Buy',
                            style: tt.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 18,
                  bottom: MediaQuery.of(context).padding.bottom + 18,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.balanceBarColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.balanceBarColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Text(
                  balanceText,
                  textAlign: TextAlign.center,
                  style: tt.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemContent({
    required Key key,
    required dynamic item,
    required String formattedPrice,
    required bool isDark,
    required TextTheme tt,
    required ColorScheme cs,
  }) {
    return Column(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: (item.iconColor as Color).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(
            item.icon as IconData,
            size: 72,
            color: item.iconColor as Color,
          ),
        ),
        const Gap(20),
        Text(
          item.name as String,
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const Gap(6),
        Text(
          formattedPrice,
          style: tt.titleLarge?.copyWith(
            color: AppTheme.priceColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(8),
        if ((item.owned as int) > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Owned: ${item.owned}',
              style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Quit Game?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        content: const Text('Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<GameProvider>().resetGame();
              context.go('/home');
            },
            child: Text(
              'Quit',
              style: TextStyle(color: AppTheme.sellColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiptDialog(GameProvider provider) {
    final purchasedItems =
        provider.items.where((item) => item.owned > 0).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const Gap(8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(16),
              Text(
                'Your Purchases',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(4),
              Text(
                'Spent: ${provider.formattedSpent}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.sellColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Gap(16),
              Expanded(
                child: purchasedItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const Gap(12),
                            Text(
                              'No purchases yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: purchasedItems.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.1),
                        ),
                        itemBuilder: (ctx, index) {
                          final pItem = purchasedItems[index];
                          final total = pItem.owned * pItem.price(provider.isIndia);
                          return ListTile(
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: pItem.iconColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                pItem.icon,
                                color: pItem.iconColor,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              pItem.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'x${pItem.owned}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Text(
                              provider.formatPrice(total),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.priceColor,
                                  ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
