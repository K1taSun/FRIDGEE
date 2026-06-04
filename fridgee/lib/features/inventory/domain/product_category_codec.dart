// Serializacja pól `category` produktu (typ + strefa przechowywania).

abstract final class ProductCategoryCodec {
  static String encode({required String type, required String storageId}) =>
      'type:$type|storageId:$storageId';

  static String? storageId(String? category) {
    if (category == null || !category.contains('storageId:')) return null;
    String? part;
    for (final segment in category.split('|')) {
      if (segment.startsWith('storageId:')) {
        part = segment;
        break;
      }
    }
    if (part == null) return null;
    final id = part.split(':').last;
    return id.isEmpty ? null : id;
  }

  static String? type(String? category) {
    if (category == null || !category.contains('type:')) return null;
    for (final segment in category.split('|')) {
      if (segment.startsWith('type:')) return segment.split(':').last;
    }
    return null;
  }

  static bool belongsToStorage(String? category, String zoneId) =>
      ProductCategoryCodec.storageId(category) == zoneId;
}
