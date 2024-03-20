import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

class ArcEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num? thickness;
  final Point3D? center;
  final num? radius;
  final num? startAngle;
  final num? endAngle;
  final Point3D? extrusionDirection;

  const ArcEntity({
    this.subclassMarker = 'AcDbArc',
    this.thickness,
    this.center,
    this.radius,
    this.startAngle,
    this.endAngle,
    this.extrusionDirection,
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
  }) : super(type: 'ARC');

  factory ArcEntity.fromMap(Map<String, dynamic> map) {
    return ArcEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbArc',
      thickness: map['thickness'],
      center: map['center'],
      radius: map['radius'],
      startAngle: map['startAngle'],
      endAngle: map['endAngle'],
      extrusionDirection: map['extrusionDirection'],
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

const defaultArcEntity = {
  'extrusionDirection': Point3D(0, 0, 1),
};

final arcEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [51],
    name: 'endAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [50],
    name: 'startAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'radius',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'center',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [39],
    name: 'thickness',
    parser: identity,
  ),
  DXFParserSnippet(
    // skip for AcDbCircle
    code: [100],
  ),
  ...commonEntitySnippets,
];

class ArcEntityParser implements EntityParser {
  @override
  final String forEntityName = 'ARC';

  final _parser = createParser(arcEntityParserSnippets, defaultArcEntity);

  @override
  CommonDxfEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return ArcEntity.fromMap({
      ...entity,
      'handle': ensureHandle(entity['handle']),
    });
  }
}
