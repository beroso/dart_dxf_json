import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

enum LeaderCreationFlag {
  textAnnotation(0),
  toleranceAnnotation(1),
  blockReferenceAnnotation(2),
  noAnnotation(3);

  final int code;

  const LeaderCreationFlag(this.code);

  static LeaderCreationFlag parse(int code) {
    return LeaderCreationFlag.values.firstWhere((e) => e.code == code);
  }
}

class LeaderEntity extends CommonDxfEntity {
  final String subclassMarker;
  final String styleName;
  final bool isArrowheadEnabled;
  final bool? isSpline;
  final LeaderCreationFlag? leaderCreationFlag;
  final bool? isHooklineSameDirection;
  final bool? isHooklineExists;
  final num? textHeight;
  final num? textWidth;
  final num? numberOfVertices;
  final List<Point3D> vertices;
  final num? byBlockColor;
  final String? associatedAnnotation;
  final Point3D? normal;
  final Point3D? horizontalDirection;
  final Point3D? offsetFromBlock;
  final Point3D? offsetFromAnnotation;

  const LeaderEntity({
    this.subclassMarker = 'AcDbLeader',
    required this.styleName,
    required this.isArrowheadEnabled,
    required this.isSpline,
    this.leaderCreationFlag,
    this.isHooklineSameDirection,
    this.isHooklineExists,
    this.textHeight,
    this.textWidth,
    this.numberOfVertices,
    this.vertices = const [],
    this.byBlockColor,
    this.associatedAnnotation,
    this.normal,
    this.horizontalDirection,
    this.offsetFromBlock,
    this.offsetFromAnnotation,
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
  }) : super(type: 'LEADER');

  factory LeaderEntity.fromMap(Map<String, dynamic> map) {
    return LeaderEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbArc',
      styleName: map['styleName'],
      isArrowheadEnabled: map['isArrowheadEnabled'],
      isSpline: map['isSpline'],
      leaderCreationFlag: map['leaderCreationFlag'] is LeaderCreationFlag?
          ? map['leaderCreationFlag']
          : LeaderCreationFlag.parse(map['leaderCreationFlag'] as int),
      isHooklineSameDirection: map['isHooklineSameDirection'],
      isHooklineExists: map['isHooklineExists'],
      textHeight: map['textHeight'],
      textWidth: map['textWidth'],
      numberOfVertices: map['numberOfVertices'],
      vertices: List.from(map['vertices']),
      byBlockColor: map['byBlockColor'],
      associatedAnnotation: map['associatedAnnotation'],
      normal: map['normal'],
      horizontalDirection: map['horizontalDirection'],
      offsetFromBlock: map['offsetFromBlock'],
      offsetFromAnnotation: map['offsetFromAnnotation'],
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

final defaultLeaderEntity = <String, dynamic>{
  'isArrowheadEnabled': true,
};

final leaderEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [213],
    name: 'offsetFromAnnotation',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [212],
    name: 'offsetFromBlock',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [211],
    name: 'horizontalDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [210],
    name: 'normal',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [340],
    name: 'associatedAnnotation',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [77],
    name: 'byBlockColor',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'vertices',
    parser: pointParser,
    isMultiple: true,
  ),
  DXFParserSnippet(
    code: [76],
    name: 'numberOfVertices',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'textWidth',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'textHeight',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [75],
    name: 'isHooklineExists',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [74],
    name: 'isHooklineSameDirection',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [73],
    name: 'leaderCreationFlag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'isSpline',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [71],
    name: 'isArrowheadEnabled',
    parser: toBoolean,
  ),
  DXFParserSnippet(
    code: [3],
    name: 'styleName',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class LeaderEntityParser implements EntityParser {
  @override
  final String forEntityName = 'LEADER';

  final _parser = createParser(
    leaderEntityParserSnippets,
    defaultLeaderEntity,
  );

  @override
  LeaderEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return LeaderEntity.fromMap(entity);
  }
}
