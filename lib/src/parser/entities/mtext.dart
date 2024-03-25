import '../../consts/consts.dart';
import '../../types.dart';
import '../dxf_iterable.dart';
import '../parse_helpers.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

enum MTextDrawingDirection {
  leftToRight(1),
  topToBottom(3),
  byStyle(5);

  final int code;

  const MTextDrawingDirection(this.code);
}

class MTextEntity extends CommonDxfEntity {
  final String subclassMarker;
  final Point3D? insertionPoint;
  final num? height;
  final num? width;
  final AttachmentPoint? attachmentPoint;
  final MTextDrawingDirection? drawingDirection;
  final String? text;
  final String? styleName;
  final Point3D extrusionDirection;
  final Point3D? direction;
  final num rotation; // radian
  final num? lineSpacingStyle;
  final num? lineSpacing;
  final num? backgroundFill;
  final num? backgroundColor;
  final num? fillBoxScale;
  final num? backgroundFillColor;
  final num? backgroundFillTransparency;
  final num? columnType;
  final num? columnCount;
  final num? columnFlowReversed;
  final num? columnAutoHeight;
  final num? columnWidth;
  final num? columnGutter;
  final num? columnHeight;
  final num? annotationHeight;

  MTextEntity({
    this.subclassMarker = 'AcDbMText',
    this.insertionPoint,
    this.height,
    this.width,
    this.attachmentPoint,
    this.drawingDirection,
    this.text,
    this.styleName,
    required this.extrusionDirection,
    this.direction,
    required this.rotation,
    this.lineSpacingStyle,
    this.lineSpacing,
    this.backgroundFill,
    this.backgroundColor,
    this.fillBoxScale,
    this.backgroundFillColor,
    this.backgroundFillTransparency,
    this.columnType,
    this.columnCount,
    this.columnFlowReversed,
    this.columnAutoHeight,
    this.columnWidth,
    this.columnGutter,
    this.columnHeight,
    this.annotationHeight,
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
  }) : super(type: 'MTEXT');

  factory MTextEntity.fromMap(Map<String, dynamic> map) {
    return MTextEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbMText',
      insertionPoint: map['insertionPoint'],
      height: map['height'],
      width: map['width'],
      attachmentPoint: map['attachmentPoint'],
      drawingDirection: map['drawingDirection'],
      text: map['text'],
      styleName: map['styleName'],
      extrusionDirection: map['extrusionDirection'],
      direction: map['direction'],
      rotation: map['rotation'],
      lineSpacingStyle: map['lineSpacingStyle'],
      lineSpacing: map['lineSpacing'],
      backgroundFill: map['backgroundFill'],
      backgroundColor: map['backgroundColor'],
      fillBoxScale: map['fillBoxScale'],
      backgroundFillColor: map['backgroundFillColor'],
      backgroundFillTransparency: map['backgroundFillTransparency'],
      columnType: map['columnType'],
      columnCount: map['columnCount'],
      columnFlowReversed: map['columnFlowReversed'],
      columnAutoHeight: map['columnAutoHeight'],
      columnWidth: map['columnWidth'],
      columnGutter: map['columnGutter'],
      columnHeight: map['columnHeight'],
      annotationHeight: map['annotationHeight'],
      handle: map['handle'] ?? '', // TODO: default workaround value? ''
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

final defaultMTextEntity = {
  'textStyle': 'STANDARD',
  'extrusionDirection': const Point3D(0, 0, 1),
  'rotation': 0,
};

final mTextEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [46],
    name: 'annotationHeight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [101],
    parser: (curr, scanner, _) {
      skipEmbeddedObject(scanner);
      return null;
    },
  ),
  DXFParserSnippet(
    code: [50],
    name: 'columnHeight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [49],
    name: 'columnGutter',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [48],
    name: 'columnWidth',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [79],
    name: 'columnAutoHeight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [78],
    name: 'columnFlowReversed',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [76],
    name: 'columnCount',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [75],
    name: 'columnType',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [441],
    name: 'backgroundFillTransparency',
    parser: identity,
  ),
  DXFParserSnippet(
    // Color to use for background fill when group code 90 is 1.
    code: [63],
    name: 'backgroundFillColor',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [45],
    name: 'fillBoxScale',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [
      430,
      431,
      432,
      433,
      434,
      435,
      436,
      437,
      438,
      439,
      440
    ], // named color
    name: 'backgroundColor',
    parser: identity, // 당장은 테이블 보기 힘들어서 놔둠 추후에 rgb화 필요
  ),
  DXFParserSnippet(
    code: [420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430], // rgb
    name: 'backgroundColor',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [90],
    name: 'backgroundFill',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [44],
    name: 'lineSpacing',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [73],
    name: 'lineSpacingStyle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [50],
    name: 'rotation',
    parser: identity, // radian
  ),
  DXFParserSnippet(
    code: [43], // vertical height of characters, 미사용
  ),
  DXFParserSnippet(
    code: [42], // horizontal width of characters, 미사용
  ),
  DXFParserSnippet(
    code: [11],
    name: 'direction',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [7],
    name: 'styleName',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [3],
    name: 'text',
    parser: (curr, scanner, entity) {
      return (entity['text'] ?? '') + curr.value;
    },
  ),
  DXFParserSnippet(
    code: [1],
    name: 'text',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'drawingDirection',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [71],
    name: 'attachmentPoint',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'width',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'height',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'insertionPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class MTextEntityParser implements EntityParser {
  @override
  final String forEntityName = 'MTEXT';

  final _parser = createParser(
    mTextEntityParserSnippets,
    defaultMTextEntity,
  );

  @override
  MTextEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return MTextEntity.fromMap(entity);
  }
}
