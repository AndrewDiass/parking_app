abstract class IMemoryStorageService {
  dynamic read({
    required String keyName,
  });

  Future<bool> delete({
    required String keyName,
  });

  Future<bool> write({
    required String keyName,
    required String value,
  });
}
