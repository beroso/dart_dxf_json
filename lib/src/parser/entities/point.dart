import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

class PointEntity extends CommonDxfEntity {
  final Point3D position;
  final num thickness;
  final Point3D extrusionDirection;
  final num angle;

  PointEntity({
    required this.position,
    required this.thickness,
    required this.extrusionDirection,
    required this.angle,
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
  }) : super(type: 'POINT');

  factory PointEntity.fromMap(Map<String, dynamic> map) {
    return PointEntity(
      position: map['position'],
      thickness: map['thickness'],
      extrusionDirection: map['extrusionDirection'],
      angle: map['angle'],
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

final defaultPointEntity = <String, dynamic>{
  'thickness': 0,
  'extrusionDirection': const Point3D(0, 0, 1),
  'angle': 0,
};

final pointEntityParserSnippets = <DXFParserSnippet>[
  // Angle of the X axis for the UCS in effect
  // when the point was drawn.
  // used when PDMODE is nonzero.
  DXFParserSnippet(
    code: [50],
    name: 'angle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [39],
    name: 'thickness',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'position',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class PointEntityParser implements EntityParser {
  @override
  final String forEntityName = 'POINT';

  final _parser = createParser(
    pointEntityParserSnippets,
    defaultPointEntity,
  );

  @override
  PointEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return PointEntity.fromMap(entity);
  }
}
