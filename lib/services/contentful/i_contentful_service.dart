abstract class ContentfulService {
  ///Get a single entry by `id`
  Future<Map<String, dynamic>> getEntry(
    String id, {
    Map<String, dynamic> params,
  });

  ///Get all entries
  Future<Map<String, dynamic>> getEntries({
    Map<String, dynamic> params,
  });

  ///Get a single asset by `id`
  Future<Map<String, dynamic>> getAsset(String id);
}
