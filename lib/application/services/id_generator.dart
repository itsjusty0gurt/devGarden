import 'package:uuid/uuid.dart';

import '../../domain/models/entities.dart';

abstract interface class IdGenerator {
  EntityId next();
}

class UuidV7IdGenerator implements IdGenerator {
  const UuidV7IdGenerator();

  static const _uuid = Uuid();

  @override
  EntityId next() => EntityId(_uuid.v7());
}
