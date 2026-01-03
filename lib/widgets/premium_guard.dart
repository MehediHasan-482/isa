import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/app_provider.dart';

class PremiumGuard extends StatelessWidget {
  final Widget premiumChild;
  final Widget lockedChild;

  const PremiumGuard({
    super.key,
    required this.premiumChild,
    required this.lockedChild,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<AppProvider>().isPremium;
    return isPremium ? premiumChild : lockedChild;
  }
}
