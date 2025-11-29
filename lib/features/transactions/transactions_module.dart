import 'package:flutter_modular/flutter_modular.dart';
import 'package:finly_app/features/transactions/presentation/pages/transactions_page.dart';

/// Transactions feature module.
/// Exposes '/transactions' root via ModuleRoute in the DashboardModule.
class TransactionsModule extends Module {
  @override
  void routes(RouteManager r) {
    // /transactions -> TransactionsPage
    r.child('/', child: (context) => const TransactionsPage());
  }
}
