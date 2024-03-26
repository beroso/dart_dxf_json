import '../shared/parser_generator.dart';
import 'common.dart';

class DictionaryDXFObject extends CommonDXFObject {
  final String subclassMarker;
  final bool? isHardOwned;
  final RecordCloneFlag recordCloneFlag;
  final List<DictionaryDxfEntry> entries;

  DictionaryDXFObject({
    this.subclassMarker = 'AcDbDictionary',
    required super.ownerObjectId,
    required super.ownerDictionaryIdHard,
    required super.ownerDictionaryIdSoft,
    required super.handle,
    required this.isHardOwned,
    required this.recordCloneFlag,
    required this.entries,
  });
}

class DictionaryDxfEntry {
  final String name;
  final String? objectId;

  DictionaryDxfEntry({required this.name, required this.objectId});
}

final dictionarySnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [3],
    name: 'entries',
    parser: (curr, scanner, _) {
      final name = curr.value as String;
      String? objectId;
      curr = scanner.next();
      if (curr.code == 350) {
        objectId = curr.value as String?;
      } else {
        scanner.rewind();
      }
      return DictionaryDxfEntry(name: name, objectId: objectId);
    },
    isMultiple: true,
  ),
  DXFParserSnippet(
    code: [281],
    name: 'recordCloneFlag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [280],
    name: 'isHardOwned',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
];

enum RecordCloneFlag {
  notApplicable(0),
  keepExisting(1),
  useClone(2),
  xrefValueName(3),
  valueName(4),
  unmangleName(5);

  final int code;

  const RecordCloneFlag(this.code);
}
