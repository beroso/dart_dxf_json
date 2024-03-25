import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';
import 'text.dart';

enum AttributeFlag {
  none(0),
  invisible(1),
  constant(2),
  verificationRequired(4),
  preset(8);

  final int code;

  const AttributeFlag(this.code);
}

enum AttDefMTextFlag {
  multiline(2),
  constantMultiline(4);

  final int code;

  const AttDefMTextFlag(this.code);
}

class AttdefEntity extends TextEntity {
  @override
  String get type => 'ATTDEF';

  final String? prompt;
  final String? tag;
  final num? attributeFlag;
  final bool? isLocked;
  final bool? isDuplicatedRecord;
  final num? mtextFlag;
  final bool? isReallyLocked;
  final num? numberOfSecondaryAttributes;
  final List<String> secondaryAttributesHardIds;
  final Point3D? alignmentPoint;
  final num? annotationScale;

  AttdefEntity({
    this.prompt,
    this.tag,
    this.attributeFlag,
    this.isLocked,
    this.isDuplicatedRecord,
    this.mtextFlag,
    this.isReallyLocked,
    this.numberOfSecondaryAttributes,
    this.secondaryAttributesHardIds = const [],
    this.alignmentPoint,
    this.annotationScale,
    // From TextEntity
    super.subclassMarker = 'AcDbAttributeDefinition',
    required super.text,
    required super.thickness,
    super.startPoint,
    super.endPoint,
    super.textHeight,
    required super.rotation,
    required super.xScale,
    required super.obliqueAngle,
    required super.styleName,
    required super.generationFlag,
    required super.halign,
    required super.valign,
    required super.extrusionDirection,
    // From CommonDxfEntity
    required super.handle,
    super.ownerBlockRecordSoftId,
    super.isInPaperSpace,
    required super.layer,
    super.lineType,
    super.materialObjectHardId,
    super.colorIndex,
    super.lineweight,
    super.lineTypeScale,
    super.isVisible,
    super.proxyByte,
    super.proxyEntity,
    super.color,
    super.colorName,
    super.transparency,
    super.plotStyleHardId,
    super.shadowMode,
    super.xdata,
    super.ownerdictionaryHardId,
    super.ownerDictionarySoftId,
  });

  factory AttdefEntity.fromMap(Map<String, dynamic> map) {
    return AttdefEntity(
      prompt: map['prompt'],
      tag: map['tag'],
      attributeFlag: map['attributeFlag'],
      isLocked: map['isLocked'],
      isDuplicatedRecord: map['isDuplicatedRecord'],
      mtextFlag: map['mtextFlag'],
      isReallyLocked: map['isReallyLocked'],
      numberOfSecondaryAttributes: map['numberOfSecondaryAttributes'],
      secondaryAttributesHardIds: map['secondaryAttributesHardIds'] ?? [],
      alignmentPoint: map['alignmentPoint'],
      annotationScale: map['annotationScale'],
      subclassMarker: map['subclassMarker'] ?? 'AcDbAttributeDefinition',
      text: map['text'],
      thickness: map['thickness'],
      startPoint: map['startPoint'],
      endPoint: map['endPoint'],
      textHeight: map['textHeight'],
      rotation: map['rotation'],
      xScale: map['xScale'],
      obliqueAngle: map['obliqueAngle'],
      styleName: map['styleName'],
      generationFlag: map['generationFlag'],
      halign: map['halign'] is TextHorizontalAlign
          ? map['halign']
          : TextHorizontalAlign.parse(map['halign'] as int),
      valign: map['valign'] is TextVerticalAlign
          ? map['valign']
          : TextVerticalAlign.parse(map['valign'] as int),
      extrusionDirection: map['extrusionDirection'],
      handle: ensureHandle(map['handle']),
      ownerBlockRecordSoftId: map['ownerBlockRecordSoftId'],
      isInPaperSpace: map['isInPaperSpace'],
      layer: map['layer'] ?? '', // TODO: default workaround value? ''
      lineType: map['lineType'],
      materialObjectHardId: map['materialObjectHardId'],
      colorIndex: map['colorIndex'],
      lineweight: map['lineweight'],
      lineTypeScale: map['lineTypeScale'],
      isVisible: map['isVisible'],
      proxyByte: map['proxyByte'],
      proxyEntity: map['proxyEntity'],
      color: map['color'],
      colorName: map['colorName'],
      transparency: map['transparency'],
      plotStyleHardId: map['plotStyleHardId'],
      shadowMode: map['shadowMode'],
      xdata: map['xdata'],
      ownerdictionaryHardId: map['ownerdictionaryHardId'],
      ownerDictionarySoftId: map['ownerDictionarySoftId'],
    );
  }
}

final defaultAttDefEntity = {
  ...defaultTextEntity,
};

final attDefEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [2], // tag.
  ),
  DXFParserSnippet(
    code: [40],
    name: 'annotationScale',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'alignmentPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [340],
    name: 'secondaryAttributesHardIds',
    isMultiple: true,
    parser: identity,
  ),
  DXFParserSnippet(
    code: [70],
    name: 'numberOfSecondaryAttributes',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [70],
    name: 'isReallyLocked',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [70],
    name: 'mtextFlag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [280],
    name: 'isDuplicatedRecord',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [100], // AcDbXrecord, skip
  ),
  DXFParserSnippet(
    code: [280],
    name: 'isLocked',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [74],
    name: 'valign',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [73], // field length, useless
  ),
  DXFParserSnippet(
    code: [70],
    name: 'attributeFlag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [2],
    name: 'tag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [3],
    name: 'prompt',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [280], // version number, always 0, useless
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...textEntityParserSnippets.skip(2),
];

class AttDefEntityParser implements EntityParser {
  @override
  final String forEntityName = 'ATTDEF';

  final _parser = createParser(
    attDefEntityParserSnippets,
    defaultAttDefEntity,
  );

  @override
  AttdefEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return AttdefEntity.fromMap(entity);
  }
}
