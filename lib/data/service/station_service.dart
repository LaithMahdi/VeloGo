import 'package:flutter/material.dart';
import '../../core/service/supabase_service.dart';
import '../model/station_model.dart';

class StationService {
  final SupabaseService _supabaseService = SupabaseService();

  // Fetch all stations
  Future<List<StationModel>> fetchStations({String? status}) async {
    try {
      var query = _supabaseService.client.from('stations').select();

      // Filter by status if provided
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query;

      debugPrint('✅ Fetched ${response.length} stations from Supabase');

      return (response as List)
          .map((json) => StationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching stations: $e');
      rethrow;
    }
  }

  // Fetch station by ID
  Future<StationModel?> fetchStationById(String stationId) async {
    try {
      final response = await _supabaseService.client
          .from('stations')
          .select()
          .eq('id', stationId)
          .single();

      debugPrint('✅ Fetched station: $stationId');
      return StationModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error fetching station by ID: $e');
      return null;
    }
  }

  // Fetch nearby stations (basic implementation - can be enhanced with PostGIS)
  Future<List<StationModel>> fetchNearbyStations({
    double? latitude,
    double? longitude,
    int limit = 10,
  }) async {
    try {
      // For now, just fetch active stations and limit results
      // TODO: Implement proper distance calculation using PostGIS or client-side filtering
      final response = await _supabaseService.client
          .from('stations')
          .select()
          .eq('status', 'active')
          .limit(limit);

      debugPrint('✅ Fetched ${response.length} nearby stations');

      return (response as List)
          .map((json) => StationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching nearby stations: $e');
      rethrow;
    }
  }

  // Fetch stations by city
  Future<List<StationModel>> fetchStationsByCity(String city) async {
    try {
      final response = await _supabaseService.client
          .from('stations')
          .select()
          .eq('city', city);

      debugPrint('✅ Fetched ${response.length} stations for city: $city');

      return (response as List)
          .map((json) => StationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching stations by city: $e');
      rethrow;
    }
  }

  // Update station available bikes count
  Future<void> updateStationAvailableBikes(String stationId, int count) async {
    try {
      await _supabaseService.client
          .from('stations')
          .update({
            'available_bikes': count,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', stationId);

      debugPrint('✅ Updated station available bikes: $stationId -> $count');
    } catch (e) {
      debugPrint('❌ Error updating station available bikes: $e');
      rethrow;
    }
  }
}
