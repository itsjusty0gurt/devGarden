import 'dart:io';

abstract interface class DatabasePathProvider {
  Future<File> databaseFile();
}

class WindowsDatabasePathProvider implements DatabasePathProvider {
  const WindowsDatabasePathProvider();

  @override
  Future<File> databaseFile() async {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'TBD — requires architectural decision before implementation.',
      );
    }
    final appData = Platform.environment['APPDATA'];
    if (appData == null || appData.isEmpty) {
      throw const FileSystemException(
        'Windows application-data directory is unavailable.',
      );
    }
    final directory = Directory('$appData${Platform.pathSeparator}devGarden');
    await directory.create(recursive: true);
    return File('${directory.path}${Platform.pathSeparator}devGarden.sqlite');
  }
}
