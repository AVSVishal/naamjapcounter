import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final purchasedItems =
        provider.items.where((item) => item.owned > 0).toList();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(24),
            Icon(
              Icons.receipt_long_rounded,
              size: 56,
              color: AppTheme.buyColor,
            ).animate().scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),
            const Gap(12),
            Text(
              'Final Receipt',
              style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ).animate(delay: 200.ms).fadeIn(),
            const Gap(4),
            Text(
              'Spent ${provider.formattedSpent} of ${provider.formattedBudget}',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ).animate(delay: 300.ms).fadeIn(),
            const Gap(8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.buyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${provider.spentPercentage.toStringAsFixed(1)}% spent',
                style: tt.titleSmall?.copyWith(
                  color: AppTheme.buyColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ).animate(delay: 400.ms).fadeIn(),
            const Gap(20),
            Expanded(
              child: purchasedItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 48,
                            color: cs.onSurface.withValues(alpha: 0.25),
                          ),
                          const Gap(12),
                          Text(
                            'Nothing purchased!',
                            style: tt.bodyLarge?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: purchasedItems.length,
                      separatorBuilder: (_, __) => Divider(
                        color: cs.outline.withValues(alpha: 0.1),
                      ),
                      itemBuilder: (ctx, index) {
                        final pItem = purchasedItems[index];
                        final total =
                            pItem.owned * pItem.price(provider.isIndia);
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
                            style: tt.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'x${pItem.owned}',
                            style: tt.bodySmall,
                          ),
                          trailing: Text(
                            provider.formatPrice(total),
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.priceColor,
                            ),
                          ),
                        )
                            .animate(
                                delay: Duration(milliseconds: 500 + index * 60))
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: 0.1, end: 0);
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => context.go('/game'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Continue',
                          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.resetGame();
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buyColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'New Game',
                          style: tt.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
