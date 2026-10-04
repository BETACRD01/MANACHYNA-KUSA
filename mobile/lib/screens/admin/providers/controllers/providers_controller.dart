import 'package:flutter/material.dart';
import '../../../../features/admin/data/admin_repository.dart';
// Ensure AdminProvider is available

class ProvidersController extends ChangeNotifier {
  final AdminRepository repository;
  
  List<AdminProvider> providers = [];
  bool loading = true;
  String? error;
  String? busyProviderId;
  String statusFilter = 'all';
  final TextEditingController searchCtrl = TextEditingController();

  ProvidersController({required this.repository}) {
    load();
  }

  void setStatusFilter(String filter) {
    statusFilter = filter;
    notifyListeners();
    load();
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    
    try {
      final result = await repository.loadProviders(
        search: searchCtrl.text,
        statusFilter: statusFilter,
      );
      providers = result.items;
      loading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future<void> doAction(AdminProvider provider, String action, BuildContext context) async {
    busyProviderId = provider.id;
    notifyListeners();
    
    try {
      if (action == 'approve') {
        await repository.approveProvider(provider.id);
      } else if (action == 'suspend') {
        await repository.suspendProvider(provider.id);
      } else {
        await repository.reactivateProvider(provider.id);
      }
      busyProviderId = null;
      notifyListeners();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proveedor actualizado correctamente'))
        );
      }
      await load();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
        );
      }
      busyProviderId = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }
}
