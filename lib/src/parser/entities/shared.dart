import '../dxf_iterable.dart';
import '../parse_helpers.dart';
import '../shared/is_matched.dart';
import '../shared/parser_generator.dart';

class CommonDxfEntity {
  final String type;
  final String handle;
  final String? ownerBlockRecordSoftId;
  final bool? isInPaperSpace;
  final String layer;
  final String? lineType;
  final String? materialObjectHardId;
  // TODO: ColorIndex
  // final ColorIndex? colorIndex;
  final Object? colorIndex;
  final num? lineweight;
  final num? lineTypeScale;
  final bool? isVisible;
  final num? proxyByte;
  final String? proxyEntity;
  // TODO: ColorInstance
  // final ColorInstance? color;
  final Object? color;
  final String? colorName;
  final num? transparency;
  final String? plotStyleHardId;
  final ShadowMode? shadowMode;
  // TODO: XData
  // final XData? xdata;
  final Object? xdata;
  final Object? ownerdictionaryHardId; // String | num | bool
  final Object? ownerDictionarySoftId; // String | num | bool

  const CommonDxfEntity({
    required this.type,
    required this.handle,
    this.ownerBlockRecordSoftId,
    this.isInPaperSpace,
    required this.layer,
    this.lineType,
    this.materialObjectHardId,
    this.colorIndex,
    this.lineweight,
    this.lineTypeScale,
    this.isVisible,
    this.proxyByte,
    this.proxyEntity,
    this.color,
    this.colorName,
    this.transparency,
    this.plotStyleHardId,
    this.shadowMode,
    this.xdata,
    this.ownerdictionaryHardId,
    this.ownerDictionarySoftId,
  });
}

enum ShadowMode {
  castAndReceive(0),
  cast(1),
  receive(2),
  ignore(3);

  const ShadowMode(this.code);

  final int code;
}

abstract interface class EntityParser {
  String get forEntityName;

  CommonDxfEntity parseEntity(DxfIterator scanner, ScannerGroup curr);
}

final commonEntitySnippets = <DXFParserSnippet>[
  // ...XDataParserSnippets,
  DXFParserSnippet(
    code: [284],
    name: 'shadowMode',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [390],
    name: 'plotStyleHardId',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [440],
    name: 'transparency',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [430],
    name: 'colorName',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [420],
    name: 'color',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [310],
    name: 'proxyEntity',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [92],
    name: 'proxyByte',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [60],
    name: 'isVisible',
    parser: toBoolean,
  ),

  DXFParserSnippet(
    code: [48],
    name: 'lineTypeScale',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [370],
    name: 'lineweight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [62],
    name: 'colorIndex',
    parser: (curr, scanner, entity) {
      final colorIndex = curr.value;
      entity['color'] = getAcadColor((colorIndex as int).abs());
      return colorIndex;
    },
  ),
  DXFParserSnippet(
    code: [347],
    name: 'materialObjectHardId',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [6],
    name: 'lineType',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [8],
    name: 'layer',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [410],
    name: 'layoutTabName',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [67],
    name: 'isInPaperSpace',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [100], // AcDbEntity
  ),
  DXFParserSnippet(
    code: [330],
    name: 'ownerBlockRecordSoftId',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [102], // {ACAD_XDICTIONARY
    parser: skipApplicationGroups,
  ),
  DXFParserSnippet(
    code: [102], // {ACAD_REACTORS
    parser: skipApplicationGroups,
  ),
  DXFParserSnippet(
    code: [102], // {application_name
    parser: skipApplicationGroups,
  ),
  DXFParserSnippet(
    code: [5],
    name: 'handle',
    parser: identity,
  ),
];

skipApplicationGroups(
  ScannerGroup curr,
  DxfIterator scanner, [
  Map<String, dynamic>? entity,
]) {
  curr = scanner.next();
  while (!isMatched(curr, 102) && !isMatched(curr, 0, 'EOF')) {
    curr = scanner.next();
  }
}
