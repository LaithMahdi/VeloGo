import 'package:flutter/material.dart';
import '../../core/service/supabase_service.dart';
import '../model/bike_model.dart';

class BikeService {
  final SupabaseService _supabaseService = SupabaseService();

  // Fetch all available bikes
  Future<List<BikeModel>> fetchBikes({String? status}) async {
    try {
      var query = _supabaseService.client.from('bikes').select();

      // Filter by status if provided
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query;

      debugPrint('✅ Fetched ${response.length} bikes from Supabase');

      return (response as List)
          .map((json) => BikeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching bikes: $e');
      rethrow;
    }
  }

  // Fetch bike by ID
  Future<BikeModel?> fetchBikeById(String bikeId) async {
    try {
      final response = await _supabaseService.client
          .from('bikes')
          .select()
          .eq('id', bikeId)
          .single();

      debugPrint('✅ Fetched bike: $bikeId');
      return BikeModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error fetching bike by ID: $e');
      return null;
    }
  }

  // Fetch bike by QR code
  Future<BikeModel?> fetchBikeByQRCode(String qrCode) async {
    try {
      final response = await _supabaseService.client
          .from('bikes')
          .select()
          .eq('qr_code', qrCode)
          .single();

      debugPrint('✅ Fetched bike by QR code: $qrCode');
      return BikeModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error fetching bike by QR code: $e');
      return null;
    }
  }

  // Fetch bikes at a specific station
  Future<List<BikeModel>> fetchBikesByStation(String stationId) async {
    try {
      final response = await _supabaseService.client
          .from('bikes')
          .select()
          .eq('station_id', stationId);

      debugPrint('✅ Fetched ${response.length} bikes for station: $stationId');

      return (response as List)
          .map((json) => BikeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching bikes by station: $e');
      rethrow;
    }
  }

  // Update bike status
  Future<void> updateBikeStatus(String bikeId, String status) async {
    try {
      await _supabaseService.client
          .from('bikes')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bikeId);

      debugPrint('✅ Updated bike status: $bikeId -> $status');
    } catch (e) {
      debugPrint('❌ Error updating bike status: $e');
      rethrow;
    }
  }

  // Update bike location (station)
  Future<void> updateBikeStation(String bikeId, String? stationId) async {
    try {
      await _supabaseService.client
          .from('bikes')
          .update({
            'station_id': stationId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bikeId);

      debugPrint('✅ Updated bike station: $bikeId -> $stationId');
    } catch (e) {
      debugPrint('❌ Error updating bike station: $e');
      rethrow;
    }
  }
}
