import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/service/supabase_service.dart';

class StatsService {
  final SupabaseClient _supabase = SupabaseService().client;

  /// Get total number of profiles/users
  Future<int> getTotalProfiles() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      throw Exception('Failed to get total profiles: $e');
    }
  }

  /// Get total balance from all profiles
  Future<double> getTotalBalance() async {
    try {
      final response = await _supabase.from('profiles').select('balance');

      if (response.isEmpty) {
        return 0.0;
      }

      double totalBalance = 0.0;
      for (var profile in response) {
        totalBalance += (profile['balance'] as num?)?.toDouble() ?? 0.0;
      }

      return totalBalance;
    } catch (e) {
      throw Exception('Failed to get total balance: $e');
    }
  }

  /// Get total number of rentals
  Future<int> getTotalRentals() async {
    try {
      final response = await _supabase
          .from('rentals')
          .select('id')
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      throw Exception('Failed to get total rentals: $e');
    }
  }

  /// Get all statistics at once
  Future<Map<String, dynamic>> getAllStats() async {
    try {
      final results = await Future.wait([
        getTotalProfiles(),
        getTotalBalance(),
        getTotalRentals(),
      ]);

      return {
        'totalProfiles': results[0],
        'totalBalance': results[1],
        'totalRentals': results[2],
      };
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }
}
