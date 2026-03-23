import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import '../models/shop_item.dart';
import '../data/items_data.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int? _selectedBudgetIndex;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final budgets = provider.country == Country.india ? indiaBudgets : usBudgets;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(16),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF059669), Color(0xFF22C55E)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.buyColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  ),
              const Gap(16),
              Center(
                child: Text(
                  'Spend The Money',
                  style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              Center(
                child: Text(
                  'How fast can you spend it all?',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              const Gap(32),
              Text(
                'SELECT COUNTRY',
                style: tt.labelMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _CountryCard(
                      flag: Country.india.flag,
                      name: Country.india.label,
                      currency: Country.india.currencySymbol,
                      isSelected: provider.country == Country.india,
                      onTap: () {
                        provider.setCountry(Country.india);
                        setState(() => _selectedBudgetIndex = null);
                      },
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _CountryCard(
                      flag: Country.us.flag,
                      name: Country.us.label,
                      currency: Country.us.currencySymbol,
                      isSelected: provider.country == Country.us,
                      onTap: () {
                        provider.setCountry(Country.us);
                        setState(() => _selectedBudgetIndex = null);
                      },
                    ),
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const Gap(32),
              Text(
                'CHOOSE YOUR BUDGET',
                style: tt.labelMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 300.ms),
              const Gap(12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  final isSelected = _selectedBudgetIndex == index;
                  return _BudgetCard(
                    label: budget.label,
                    subtitle: budget.subtitle,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedBudgetIndex = index),
                  ).animate(delay: Duration(milliseconds: 550 + index * 80)).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
                },
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedBudgetIndex != null
                      ? () {
                          final budget = budgets[_selectedBudgetIndex!];
                          provider.startGame(budget.amount);
                          context.go('/game');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.buyColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: cs.onSurface.withValues(alpha: 0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'START SPENDING',
                        style: tt.titleMedium?.copyWith(
                          color: _selectedBudgetIndex != null
                              ? Colors.white
                              : cs.onSurface.withValues(alpha: 0.38),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const Gap(8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _selectedBudgetIndex != null
                            ? Colors.white
                            : cs.onSurface.withValues(alpha: 0.38),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 900.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final String flag;
  final String name;
  final String currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountryCard({
    required this.flag,
    required this.name,
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.buyColor.withValues(alpha: 0.08) : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.buyColor : cs.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const Gap(8),
            Text(
              name,
              style: tt.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.buyColor : cs.onSurface,
              ),
            ),
            Text(
              currency,
              style: tt.bodySmall?.copyWith(
                color: isSelected ? AppTheme.buyColor : cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _BudgetCard({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.buyColor.withValues(alpha: 0.08) : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.buyColor : cs.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: tt.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.buyColor : cs.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(4),
            Text(
              subtitle,
              style: tt.bodySmall?.copyWith(
                color: isSelected ? AppTheme.buyColor.withValues(alpha: 0.7) : cs.onSurface.withValues(alpha: 0.45),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
