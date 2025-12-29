import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/service/supabase_service.dart';
import '../model/rental_model.dart';

class RentalService {
  final SupabaseClient _supabase = SupabaseService().client;

  /// Start a new rental by calling the start_rental database function
  Future<RentalModel> startRental({
    required String userId,
    required String bikeId,
    required int durationMinutes,
    required double pricePerHour,
  }) async {
    try {
      // Call the start_rental PostgreSQL function
      final response = await _supabase.rpc(
        'start_rental',
        params: {
          'p_user_id': userId,
          'p_bike_id': bikeId,
          'p_duration_minutes': durationMinutes,
          'p_price_per_hour': pricePerHour,
        },
      );

      if (response == null) {
        throw Exception('Failed to start rental: No response from server');
      }

      // Fetch the complete rental data with bike details
      final rentalData = await _supabase
          .from('rentals')
          .select('''
            id,
            user_id,
            bike_id,
            start_time,
            end_time,
            duration_minutes,
            planned_end_time,
            price_per_hour,
            total_cost,
            status,
            bikes:bike_id (
              id,
              station_id,
              model,
              bike_type,
              qr_code,
              status,
              battery_level,
              condition_score,
              image_url,
              price_per_hour
            )
          ''')
          .eq('id', response)
          .single();

      return RentalModel.fromJson(rentalData);
    } catch (e) {
      throw Exception('Failed to start rental: $e');
    }
  }

  /// Complete/end a rental by calling the complete_rental database function
  Future<RentalModel> completeRental({
    required String rentalId,
    required String stationId,
  }) async {
    try {
      // Call the complete_rental PostgreSQL function
      await _supabase.rpc(
        'complete_rental',
        params: {'p_rental_id': rentalId, 'p_station_id': stationId},
      );

      // Fetch the updated rental data
      final rentalData = await _supabase
          .from('rentals')
          .select('''
            id,
            user_id,
            bike_id,
            start_time,
            end_time,
            duration_minutes,
            planned_end_time,
            price_per_hour,
            total_cost,
            status,
            bikes:bike_id (
              id,
              station_id,
              model,
              bike_type,
              qr_code,
              status,
              battery_level,
              condition_score,
              image_url,
              price_per_hour
            )
          ''')
          .eq('id', rentalId)
          .single();

      return RentalModel.fromJson(rentalData);
    } catch (e) {
      throw Exception('Failed to complete rental: $e');
    }
  }

  /// Get active rental for a user
  Future<RentalModel?> getActiveRental(String userId) async {
    try {
      final response = await _supabase
          .from('rentals')
          .select('''
            id,
            user_id,
            bike_id,
            start_time,
            end_time,
            duration_minutes,
            planned_end_time,
            price_per_hour,
            total_cost,
            status,
            bikes:bike_id (
              id,
              station_id,
              model,
              bike_type,
              qr_code,
              status,
              battery_level,
              condition_score,
              image_url,
              price_per_hour
            )
          ''')
          .eq('user_id', userId)
          .eq('status', 'active')
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return RentalModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get active rental: $e');
    }
  }

  /// Get rental history for a user
  Future<List<RentalModel>> getRentalHistory(String userId) async {
    try {
      final response = await _supabase
          .from('rentals')
          .select('''
            id,
            user_id,
            bike_id,
            start_time,
            end_time,
            duration_minutes,
            planned_end_time,
            price_per_hour,
            total_cost,
            status,
            bikes:bike_id (
              id,
              station_id,
              model,
              bike_type,
              qr_code,
              status,
              battery_level,
              condition_score,
              image_url,
              price_per_hour
            )
          ''')
          .eq('user_id', userId)
          .order('start_time', ascending: false);

      return (response as List)
          .map((rental) => RentalModel.fromJson(rental))
          .toList();
    } catch (e) {
      throw Exception('Failed to get rental history: $e');
    }
  }

  /// Calculate current cost for an active rental
  Future<double> calculateCurrentCost(String rentalId) async {
    try {
      final response = await _supabase.rpc(
        'calculate_rental_cost',
        params: {'p_rental_id': rentalId},
      );

      return (response as num).toDouble();
    } catch (e) {
      throw Exception('Failed to calculate rental cost: $e');
    }
  }
}
