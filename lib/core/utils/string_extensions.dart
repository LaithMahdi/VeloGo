extension StringExtensions on String {
  /// If this exception string contains a pattern thrown by our model parsing
  /// (e.g. `Required key "<key>" is missing or null`), return a short
  /// human-friendly message pointing to that key. Otherwise return `this`.
  String extractMissingKeyMessage() {
    try {
      final regex = RegExp(r'Required key "([^"]+)" is missing or null');
      final match = regex.firstMatch(this);
      if (match != null && match.groupCount >= 1) {
        final key = match.group(1);
        return 'Missing required field: $key';
      }

      // Sometimes the error may include our "Unexpected RPC response shape" message
      final rpcRegex = RegExp(r'Unexpected RPC response shape: .* - (.*)');
      final rpcMatch = rpcRegex.firstMatch(this);
      if (rpcMatch != null && rpcMatch.groupCount >= 1) {
        return 'Unexpected RPC response: ${rpcMatch.group(1)}';
      }

      // Fall back to original string
      return this;
    } catch (_) {
      return this;
    }
  }
}
