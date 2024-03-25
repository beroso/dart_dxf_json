import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

class CircleEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num thickness;
  final Point3D? center;
  final num? radius;
  final Point3D extrusionDirection;

  const CircleEntity({
    this.subclassMarker = 'AcDbCircle',
    required this.thickness,
    this.center,
    this.radius,
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
  }) : super(type: 'CIRCLE');

  factory CircleEntity.fromMap(Map<String, dynamic> map) {
    return CircleEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbCircle',
      thickness: map['thickness'],
      center: map['center'],
      radius: map['radius'],
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

final defaultCircleEntity = {
  'thickness': 0,
  'extrusionDirection': const Point3D(0, 0, 1),
};

final circleEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
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
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class CircleEntityParser implements EntityParser {
  @override
  final String forEntityName = 'CIRCLE';
  final _parser = createParser(
    circleEntityParserSnippets,
    defaultCircleEntity,
  );

  @override
  CircleEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return CircleEntity.fromMap(entity);
  }
}
