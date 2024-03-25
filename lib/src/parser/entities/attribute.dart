import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/is_matched.dart';
import '../shared/parser_generator.dart';
import 'mtext.dart';
import 'shared.dart';

enum AttributeFlag {
  invisible(1),
  constant(2),
  requireVerification(4),
  preset(8);

  final int code;

  const AttributeFlag(this.code);
}

class AttributeEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num thickness;
  final Point3D startPoint;
  final num? textHeight;
  final String text;
  final String tag; // cannot contain spaces
  final num? attributeFlag;
  final num? lineSpacing;
  final num rotation;
  final num scale;
  final num obliqueAngle;
  final String textStyle;
  final num textGenerationFlag;
  final num horizontalJustification;
  final num verticalJustification;
  final Point3D extrusionDirection;
  final bool? lockPositionFlag;
  final bool? isDuplicatedEntriesKeep;
  final num? mtextFlag; // 2 | 4;
  final bool? isReallyLocked;
  final num? numberOfSecondaryAttributes;
  final String? secondaryAttributesHardId;
  final Point3D alignmentPoint;
  final num? annotationScale;
  final String? definitionTag;

  AttributeEntity({
    this.subclassMarker = 'AcDbAttribute',
    required this.thickness,
    required this.startPoint,
    this.textHeight,
    required this.text,
    required this.tag,
    this.attributeFlag,
    this.lineSpacing,
    required this.rotation,
    required this.scale,
    required this.obliqueAngle,
    required this.textStyle,
    required this.textGenerationFlag,
    required this.horizontalJustification,
    required this.verticalJustification,
    required this.extrusionDirection,
    this.lockPositionFlag,
    this.isDuplicatedEntriesKeep,
    this.mtextFlag,
    this.isReallyLocked,
    this.numberOfSecondaryAttributes,
    this.secondaryAttributesHardId,
    required this.alignmentPoint,
    this.annotationScale,
    this.definitionTag,
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
  }) : super(type: 'ATTRIB');

  factory AttributeEntity.fromMap(Map<String, dynamic> map) {
    return AttributeEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbAttribute',
      thickness: map['thickness'],
      startPoint: map['startPoint'],
      textHeight: map['textHeight'],
      text: map['text'],
      tag: map['tag'],
      attributeFlag: map['attributeFlag'],
      lineSpacing: map['lineSpacing'],
      rotation: map['rotation'],
      scale: map['scale'],
      obliqueAngle: map['obliqueAngle'],
      textStyle: map['textStyle'],
      textGenerationFlag: map['textGenerationFlag'],
      horizontalJustification: map['horizontalJustification'],
      verticalJustification: map['verticalJustification'],
      extrusionDirection: map['extrusionDirection'],
      lockPositionFlag: map['lockPositionFlag'],
      isDuplicatedEntriesKeep: map['isDuplicatedEntriesKeep'],
      mtextFlag: map['mtextFlag'],
      isReallyLocked: map['isReallyLocked'],
      numberOfSecondaryAttributes: map['numberOfSecondaryAttributes'],
      secondaryAttributesHardId: map['secondaryAttributesHardId'],
      alignmentPoint: map['alignmentPoint'],
      annotationScale: map['annotationScale'],
      definitionTag: map['definitionTag'],
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

final defaultAttributeEntity = {
  'thickness': 0,
  'rotation': 0,
  'scale': 1,
  'obliqueAngle': 0,
  'textStyle': 'STANDARD',
  'textGenerationFlag': 0,
  'horizontalJustification': 0,
  'verticalJustification': 0,
  'extrusionDirection': const Point3D(0, 0, 1),
};

final attributeSnippets = <DXFParserSnippet>[
  ...mTextEntityParserSnippets.sublist(
    mTextEntityParserSnippets.indexWhere((s) => s.name == 'columnType'),
    mTextEntityParserSnippets.indexWhere((s) => s.name == 'subclassMarker') + 1,
  ),
  DXFParserSnippet(
    code: [100], // AcDbEntity
  ),
  DXFParserSnippet(
    code: [0],
    parser: (curr, _, __) {
      if (!isMatched(curr, 0, 'MTEXT')) return abort;
      return null;
    },
  ),
  DXFParserSnippet(
    code: [2],
    name: 'definitionTag',
    parser: identity,
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
    name: 'secondaryAttributesHardId',
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
    name: 'isDuplicatedEntriesKeep',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [100], // AcDbXRecord
  ),
  DXFParserSnippet(
    code: [280],
    name: 'lockPositionFlag',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [11],
    name: 'alignmentPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [74],
    name: 'verticalJustification',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'horizontalJustification',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [71],
    name: 'textGenerationFlag', // attachmentPoint
    parser: identity,
  ),
  DXFParserSnippet(
    code: [7],
    name: 'textStyle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [51],
    name: 'obliqueAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'scale',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [50],
    name: 'rotation',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [73],
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
    code: [280], // version number
  ),
  DXFParserSnippet(
    code: [100], // AcDbAttribute
    name: 'subclassMarker',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [1],
    name: 'text',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'textHeight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'startPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [39],
    name: 'thickness',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [100], // AcDbText
  ),
  ...commonEntitySnippets,
];

class AttributeEntityParser implements EntityParser {
  @override
  final String forEntityName = 'ATTRIB';
  final _parser = createParser(attributeSnippets, defaultAttributeEntity);

  @override
  AttributeEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return AttributeEntity.fromMap(entity);
  }
}
