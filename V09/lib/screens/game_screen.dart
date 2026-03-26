import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/shop_item.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final _qtyController = TextEditingController(text: '1');
  final _qtyFocus = FocusNode();
  GameMode _mode = GameMode.normal;

  late AnimationController _balanceAnimController;
  int _displayedBalance = 0;
  int _previousBalance = 0;

  final Map<int, int> _gridQty = {};
  
  // Banner ad
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _balanceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    final provider = context.read<GameProvider>();
    _displayedBalance = provider.balance;
    _previousBalance = provider.balance;
    
    // Load banner ad for Game Screen
    _loadBannerAd();
    
    // Track game screen view
    AnalyticsService().logScreenView('game_screen');
    AnalyticsService().startScreenTime('game_screen');
  }
  
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7484296346485733/1640785345',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _isBannerLoaded = false);
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _qtyFocus.dispose();
    _balanceAnimController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _animateBalance(int from, int to) {
    _previousBalance = from;
    _balanceAnimController.reset();
    _balanceAnimController.addListener(_balanceListener);
    _balanceAnimController.forward().then((_) {
      _balanceAnimController.removeListener(_balanceListener);
      if (mounted) setState(() => _displayedBalance = to);
    });
  }

  void _balanceListener() {
    final provider = context.read<GameProvider>();
    if (mounted) {
      setState(() {
        _displayedBalance = (_previousBalance +
                (_balanceAnimController.value * (provider.balance - _previousBalance)))
            .round();
      });
    }
  }

  void _onBuy() {
    final provider = context.read<GameProvider>();
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final oldBal = provider.balance;
    final item = provider.currentItem;
    final price = item.price(provider.isIndia);
    
    if (provider.buyItem(qty)) {
      _animateBalance(oldBal, provider.balance);
      FocusScope.of(context).unfocus();
      
      // Track purchase
      AnalyticsService().logItemPurchase(
        itemName: item.name,
        price: price,
        quantity: qty,
        itemCategory: item.category,
        remainingBudget: provider.balance.toDouble(),
        totalOwned: item.owned,
      );
      
      // Trigger interstitial ad after purchase (every 5th with cooldown)
      AdService().onPurchaseMade();
    } else {
      _showSnack(provider.lastMessage);
    }
  }

  void _onSell() {
    final provider = context.read<GameProvider>();
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final oldBal = provider.balance;
    if (provider.sellItem(qty)) {
      _animateBalance(oldBal, provider.balance);
      FocusScope.of(context).unfocus();
    } else {
      _showSnack(provider.lastMessage);
    }
  }

  void _onGridBuy(int itemIndex, int qty) {
    final provider = context.read<GameProvider>();
    final oldIdx = provider.currentIndex;
    provider.goToItem(itemIndex);
    final oldBal = provider.balance;
    final item = provider.currentItem;
    final price = item.price(provider.isIndia);
    
    if (provider.buyItem(qty)) {
      _animateBalance(oldBal, provider.balance);
      setState(() => _gridQty[itemIndex] = 1);
      
      // Track grid purchase
      AnalyticsService().logItemPurchase(
        itemName: item.name,
        price: price,
        quantity: qty,
        itemCategory: item.category,
        remainingBudget: provider.balance.toDouble(),
        totalOwned: item.owned,
      );
      AnalyticsService().logButtonClick(
        'grid_buy',
        parameters: {
          'item_name': item.name,
          'item_index': itemIndex,
        },
      );
      
      // Trigger interstitial ad after purchase (every 5th with cooldown)
      AdService().onPurchaseMade();
    } else {
      _showSnack(provider.lastMessage);
    }
    provider.goToItem(oldIdx);
  }

  void _onGridSell(int itemIndex, int qty) {
    final provider = context.read<GameProvider>();
    final oldIdx = provider.currentIndex;
    provider.goToItem(itemIndex);
    final oldBal = provider.balance;
    if (provider.sellItem(qty)) {
      _animateBalance(oldBal, provider.balance);
      setState(() => _gridQty[itemIndex] = 1);
    } else {
      _showSnack(provider.lastMessage);
    }
    provider.goToItem(oldIdx);
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

  void _navigateItem(int dir) {
    final provider = context.read<GameProvider>();
    _qtyController.text = '1';
    FocusScope.of(context).unfocus();
    if (dir > 0) provider.nextItem();
    if (dir < 0) provider.prevItem();
  }

  void _incrementQty() {
    final current = int.tryParse(_qtyController.text) ?? 0;
    _qtyController.text = '${current + 1}';
  }

  void _decrementQty() {
    final current = int.tryParse(_qtyController.text) ?? 0;
    if (current > 1) _qtyController.text = '${current - 1}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    if (_displayedBalance != provider.balance && !_balanceAnimController.isAnimating) {
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
        if (!didPop) _showExitDialog();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(provider),
                Expanded(
                  child: switch (_mode) {
                    GameMode.normal => _buildNormalMode(provider),
                    GameMode.grid => _buildGridMode(provider),
                    GameMode.reel => _buildReelMode(provider),
                  },
                ),
                // Banner ad - NOT shown in Reel mode (as requested)
                if (_mode != GameMode.reel && _isBannerLoaded && _bannerAd != null)
                  Container(
                    alignment: Alignment.center,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                _buildBalanceBar(balanceText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: _showExitDialog,
            icon: const Icon(Icons.close_rounded, color: Color(0xFF666666)),
          ),
          const Spacer(),
          _buildModeChip(GameMode.normal, Icons.view_agenda_outlined, 'Normal'),
          const Gap(4),
          _buildModeChip(GameMode.grid, Icons.grid_view_outlined, 'Grid'),
          const Gap(4),
          _buildModeChip(GameMode.reel, Icons.videocam_outlined, 'Reel'),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Track receipt button click
              AnalyticsService().logButtonClick('receipt_button');
              _showReceiptSheet(provider);
            },
            icon: const Icon(Icons.receipt_long_outlined, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(GameMode mode, IconData icon, String label) {
    final isActive = _mode == mode;
    return GestureDetector(
      onTap: () {
        final oldMode = _mode;
        setState(() => _mode = mode);
        
        // Track mode switch
        AnalyticsService().logGameModeSwitched(
          mode.toString().split('.').last,
          fromMode: oldMode.toString().split('.').last,
        );
        AnalyticsService().logButtonClick(
          'mode_switch',
          parameters: {
            'to_mode': mode.toString().split('.').last,
            'from_mode': oldMode.toString().split('.').last,
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.buyColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : const Color(0xFF666666)),
            if (isActive) ...[
              const Gap(4),
              Text(label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF666666),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  // ─── NORMAL MODE (SCROLLABLE) ──────────────────────────
  Widget _buildNormalMode(GameProvider provider) {
    final item = provider.currentItem;
    final price = item.price(provider.isIndia);
    final formattedPrice = provider.formatPrice(price);

    return GestureDetector(
      onHorizontalDragEnd: (d) {
        if (d.primaryVelocity != null) {
          if (d.primaryVelocity! < -100) _navigateItem(1);
          if (d.primaryVelocity! > 100) _navigateItem(-1);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Column(
            key: ValueKey(provider.currentIndex),
            children: [
              const Gap(12),
              _buildItemImage(item, size: 220),
              const Gap(16),
              Text(item.name,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
              const Gap(4),
              Text(formattedPrice,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
              const Gap(8),
              if (item.owned > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Owned: ${item.owned}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                ),
              const Gap(12),
              _buildNavArrows(provider),
              const Gap(16),
              _buildQuantityRow(),
              const Gap(12),
              _buildBuySellButtons(),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavArrows(GameProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: provider.currentIndex > 0 ? () => _navigateItem(-1) : null,
          icon: Icon(Icons.chevron_left_rounded,
              size: 36,
              color: provider.currentIndex > 0
                  ? const Color(0xFF111827)
                  : const Color(0xFFD1D5DB)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text('${provider.currentIndex + 1} / ${provider.totalItems}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
        ),
        IconButton(
          onPressed: provider.currentIndex < provider.totalItems - 1
              ? () => _navigateItem(1)
              : null,
          icon: Icon(Icons.chevron_right_rounded,
              size: 36,
              color: provider.currentIndex < provider.totalItems - 1
                  ? const Color(0xFF111827)
                  : const Color(0xFFD1D5DB)),
        ),
      ],
    );
  }

  Widget _buildQuantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleBtn(Icons.remove, _decrementQty),
        const Gap(12),
        SizedBox(
          width: 100,
          height: 50,
          child: TextField(
            controller: _qtyController,
            focusNode: _qtyFocus,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ),
        const Gap(12),
        _buildCircleBtn(Icons.add, _incrementQty),
      ],
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFF3F4F6),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: Icon(icon, size: 26, color: const Color(0xFF111827)),
        ),
      ),
    );
  }

  Widget _buildBuySellButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _onSell,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sellColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.zero,
              ),
              child: const Text('Sell',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buyColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.zero,
              ),
              child: const Text('Buy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  // ─── GRID MODE ─────────────────────────────────────────
  Widget _buildGridMode(GameProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.52,
      ),
      itemCount: provider.totalItems,
      itemBuilder: (ctx, index) => _buildGridCard(provider, index),
    );
  }

  Widget _buildGridCard(GameProvider provider, int idx) {
    final item = provider.items[idx];
    final price = item.price(provider.isIndia);
    final formattedPrice = provider.formatPrice(price);
    final qty = _gridQty[idx] ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: _buildNetworkImage(item, double.infinity),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(formattedPrice,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.priceColor)),
                  if (item.owned > 0)
                    Text('Owned: ${item.owned}',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _gridSmallBtn(Icons.remove, () {
                        if (qty > 1) setState(() => _gridQty[idx] = qty - 1);
                      }),
                      Container(
                        width: 36,
                        alignment: Alignment.center,
                        child: Text('$qty',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                      ),
                      _gridSmallBtn(Icons.add, () {
                        setState(() => _gridQty[idx] = qty + 1);
                      }),
                    ],
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => _onGridSell(idx, qty),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.sellColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Sell',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ),
                      const Gap(6),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => _onGridBuy(idx, qty),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.buyColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Buy',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridSmallBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF374151)),
      ),
    );
  }

  // ─── REEL MODE (SCROLLABLE BOTTOM) ─────────────────────
  Widget _buildReelMode(GameProvider provider) {
    final item = provider.currentItem;
    final price = item.price(provider.isIndia);
    final formattedPrice = provider.formatPrice(price);

    return Column(
      children: [
        Expanded(
          flex: 35,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF059669), Color(0xFF10B981)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('SPEND THE MONEY',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    )),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Budget: ${provider.formattedBudget}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
                const Gap(6),
                Text(
                  '${provider.spentPercentage.toStringAsFixed(1)}% spent',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 65,
          child: GestureDetector(
            onHorizontalDragEnd: (d) {
              if (d.primaryVelocity != null) {
                if (d.primaryVelocity! < -100) _navigateItem(1);
                if (d.primaryVelocity! > 100) _navigateItem(-1);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  key: ValueKey(provider.currentIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const Gap(12),
                      Row(
                        children: [
                          IconButton(
                            onPressed: provider.currentIndex > 0 ? () => _navigateItem(-1) : null,
                            icon: Icon(Icons.chevron_left_rounded,
                                size: 32,
                                color: provider.currentIndex > 0
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFD1D5DB)),
                          ),
                          Expanded(
                            child: Center(child: _buildItemImage(item, size: 150)),
                          ),
                          IconButton(
                            onPressed: provider.currentIndex < provider.totalItems - 1
                                ? () => _navigateItem(1)
                                : null,
                            icon: Icon(Icons.chevron_right_rounded,
                                size: 32,
                                color: provider.currentIndex < provider.totalItems - 1
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFD1D5DB)),
                          ),
                        ],
                      ),
                      const Gap(8),
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                      Text(formattedPrice,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
                      if (item.owned > 0) ...[
                        const Gap(4),
                        Text('Owned: ${item.owned}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF))),
                      ],
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircleBtn(Icons.remove, _decrementQty),
                          const Gap(8),
                          SizedBox(
                            width: 90,
                            height: 46,
                            child: TextField(
                              controller: _qtyController,
                              focusNode: _qtyFocus,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.black, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.black, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const Gap(8),
                          _buildCircleBtn(Icons.add, _incrementQty),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _onSell,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.sellColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text('Sell',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _onBuy,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.buyColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text('Buy',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── SHARED WIDGETS ────────────────────────────────────
  Widget _buildItemImage(ShopItem item, {double size = 220}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        item.imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: item.iconColor),
              ),
            ),
          );
        },
        errorBuilder: (ctx, err, stack) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(item.icon, size: size * 0.45, color: item.iconColor),
          );
        },
      ),
    );
  }

  Widget _buildNetworkImage(ShopItem item, double width) {
    return Image.network(
      item.imageUrl,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return Container(
          color: item.iconColor.withValues(alpha: 0.06),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: item.iconColor),
            ),
          ),
        );
      },
      errorBuilder: (ctx, err, stack) {
        return Container(
          color: item.iconColor.withValues(alpha: 0.08),
          child: Icon(item.icon, size: 48, color: item.iconColor),
        );
      },
    );
  }

  Widget _buildBalanceBar(String balanceText) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
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
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit Game?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
        content: const Text('Your progress will be lost.', style: TextStyle(color: Color(0xFF6B7280))),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<GameProvider>().resetGame();
              context.go('/home');
            },
            child: const Text('Quit', style: TextStyle(color: AppTheme.sellColor)),
          ),
        ],
      ),
    );
  }

  void _showReceiptSheet(GameProvider provider) {
    final purchased = provider.items.where((i) => i.owned > 0).toList();
    
    // Track receipt viewed
    AnalyticsService().logReceiptViewed(
      purchased.length,
      provider.spent.toDouble(),
      purchased.length,
    );
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (ctx, scroll) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const Gap(8),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)),
              ),
              const Gap(16),
              const Text('Your Purchases',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
              const Gap(4),
              Text('Spent: ${provider.formattedSpent}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.sellColor)),
              const Gap(16),
              Expanded(
                child: purchased.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 48, color: Color(0xFFD1D5DB)),
                            Gap(12),
                            Text('No purchases yet', style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF))),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scroll,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: purchased.length,
                        separatorBuilder: (_, __) => const Divider(color: Color(0xFFF3F4F6)),
                        itemBuilder: (ctx, i) {
                          final p = purchased[i];
                          final total = p.owned * p.price(provider.isIndia);
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(p.imageUrl, width: 44, height: 44, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: p.iconColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(p.icon, color: p.iconColor, size: 24),
                                ),
                              ),
                            ),
                            title: Text(p.name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                            subtitle: Text('x${p.owned}', style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                            trailing: Text(provider.formatPrice(total),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.priceColor)),
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
