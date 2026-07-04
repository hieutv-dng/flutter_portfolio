import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in an external browser tab.
///
/// This is the single place the app talks to `url_launcher`, which keeps it easy
/// to mock in tests. Empty or placeholder (`#`) URLs are ignored, and any launch
/// failure is swallowed (logged in debug only) so a broken or placeholder link —
/// like the CV button's `#` — never crashes the app.
Future<void> openExternalLink(String url) async {
  final String trimmed = url.trim();
  if (trimmed.isEmpty || trimmed == '#') {
    return;
  }
  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return;
  }
  try {
    // On web this opens a new tab by default; the mode is ignored elsewhere for
    // http(s) links but keeps intent explicit.
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (error) {
    debugPrint('openExternalLink failed for "$url": $error');
  }
}
