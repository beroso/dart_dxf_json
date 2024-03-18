var lastHandle = 0;

// void ensureHandle(CommonDxfEntity? entity) {
//   if (entity == null) {
//     throw ArgumentError.notNull('entity');
//   }

//   if (entity.handle.isEmpty) {
//     // TODO: assign handle
//     // entity.handle = '${lastHandle++}';
//   }
// }

String ensureHandle(String? handle) {
  return handle ?? '${lastHandle++}';
}
