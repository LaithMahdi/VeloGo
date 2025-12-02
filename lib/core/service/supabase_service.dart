import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static SupabaseClient? _client;
  static GoTrueClient? _auth;

  // Get Supabase client
  SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase has not been initialized. Call initialize() first.',
      );
    }
    return _client!;
  }

  // Get Auth client
  GoTrueClient get auth {
    if (_auth == null) {
      throw Exception(
        'Supabase has not been initialized. Call initialize() first.',
      );
    }
    return _auth!;
  }

  // Initialize Supabase
  Future<void> initialize() async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Missing Supabase credentials in .env file');
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

      _client = Supabase.instance.client;
      _auth = _client!.auth;

      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  bool get isAuthenticated => auth.currentUser != null;
  User? get currentUser => auth.currentUser;

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> dispose() async {
    _client = null;
    _auth = null;
  }
}
