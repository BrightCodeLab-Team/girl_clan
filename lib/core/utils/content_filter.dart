/// Lightweight objectionable-content check for user-generated text.
class ContentFilter {
  static const List<String> _blockedTerms = [
    'fuck',
    'shit',
    'bitch',
    'asshole',
    'bastard',
    'cunt',
    'nigger',
    'nigga',
    'faggot',
    'retard',
    'rape',
    'kill yourself',
    'kys',
  ];

  static bool containsObjectionableContent(String text) {
    final normalized = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    for (final term in _blockedTerms) {
      if (normalized.contains(term)) return true;
    }
    return false;
  }

  static String? validationError(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    if (containsObjectionableContent(text)) {
      return 'This content contains language that is not allowed in Girl Clan.';
    }
    return null;
  }
}
