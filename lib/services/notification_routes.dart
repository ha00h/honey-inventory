String routeForNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) {
    return '/notifications';
  }

  final uri = Uri.tryParse(payload);
  if (uri != null && uri.scheme == 'honeyinventory') {
    return routeForCustomScheme(uri) ?? '/notifications';
  }

  if (payload == 'notifications' || payload == '/notifications') {
    return '/notifications';
  }

  if (payload.startsWith('product:')) {
    final productId = payload.substring('product:'.length).trim();
    if (productId.isEmpty) {
      return '/notifications';
    }
    return '/product/$productId';
  }

  if (payload.startsWith('/')) {
    return payload;
  }

  return '/notifications';
}

/// Custom scheme `honeyinventory://open/...` → GoRouter location.
String? routeForCustomScheme(Uri uri) {
  if (uri.scheme != 'honeyinventory') {
    return null;
  }

  final path = uri.path;
  if (path.isEmpty || path == '/') {
    return '/notifications';
  }
  return path;
}
