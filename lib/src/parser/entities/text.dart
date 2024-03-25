import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

enum TextGenerationFlag {
  none(0),
  mirroredX(2),
  mirroredY(4);

  final int code;

  const TextGenerationFlag(this.code);

  static TextGenerationFlag parse(int code) {
    return TextGenerationFlag.values.firstWhere((e) => e.code == code);
  }
}

enum TextHorizontalAlign {
  left(0),
  center(1),
  right(2),
  aligned(3),
  middle(4),
  fit(5);

  final int code;

  const TextHorizontalAlign(this.code);

  static TextHorizontalAlign parse(int code) {
    return TextHorizontalAlign.values.firstWhere((e) => e.code == code);
  }
}

enum TextVerticalAlign {
  baseline(0),
  bottom(1),
  middle(2),
  top(3);

  final int code;

  const TextVerticalAlign(this.code);

  static TextVerticalAlign parse(int code) {
    return TextVerticalAlign.values.firstWhere((e) => e.code == code);
  }
}

class TextEntity extends CommonDxfEntity {
  final String subclassMarker;
  final String text;
  final num thickness;
  final Point3D? startPoint;
  final Point3D? endPoint;
  final num? textHeight;
  final num rotation; // degree
  final num xScale;
  final num obliqueAngle;
  final String styleName;
  final num generationFlag;
  final TextHorizontalAlign halign;
  final TextVerticalAlign valign;
  final Point3D extrusionDirection;

  TextEntity({
    this.subclassMarker = 'AcDbText',
    required this.text,
    required this.thickness,
    required this.startPoint,
    required this.endPoint,
    required this.textHeight,
    required this.rotation,
    required this.xScale,
    required this.obliqueAngle,
    required this.styleName,
    required this.generationFlag,
    required this.halign,
    required this.valign,
    required this.extrusionDirection,
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
  }) : super(type: 'TEXT');

  factory TextEntity.fromMap(Map<String, dynamic> map) {
    return TextEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbArc',
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

final defaultTextEntity = <String, dynamic>{
  'thickness': 0,
  'rotation': 0,
  'xScale': 1,
  'obliqueAngle': 0,
  'styleName': 'STANDARD',
  'generationFlag': 0,
  'halign': TextHorizontalAlign.left,
  'valign': TextVerticalAlign.baseline,
  'extrusionDirection': const Point3D(0, 0, 1),
};

final textEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [73],
    name: 'valign',
    parser: identity,
  ),
  DXFParserSnippet(
    // skip for duplicated AcDbText
    code: [100],
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [11],
    name: 'endPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'valign',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'halign',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [71],
    name: 'generationFlag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [7],
    name: 'styleName',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [51],
    name: 'obliqueAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'xScale',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [50],
    name: 'rotation',
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
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class TextEntityParser implements EntityParser {
  @override
  final String forEntityName = 'TEXT';
  final _parser = createParser(textEntityParserSnippets, defaultTextEntity);

  @override
  TextEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return TextEntity.fromMap(entity);
  }
}
