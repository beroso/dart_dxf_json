import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

class EllipseEntity extends CommonDxfEntity {
  final String subclassMarker;
  final Point3D? center;
  final Point3D? majorAxisEndPoint;
  final Point3D extrusionDirection;
  final num? axisRatio;
  final num? startAngle; // radian
  final num? endAngle; // radian

  const EllipseEntity({
    this.subclassMarker = 'AcDbEllipse',
    this.center,
    this.majorAxisEndPoint,
    required this.extrusionDirection,
    this.axisRatio,
    this.startAngle,
    this.endAngle,
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
  }) : super(type: 'ELLIPSE');

  factory EllipseEntity.fromMap(Map<String, dynamic> map) {
    return EllipseEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbEllipse',
      center: map['center'],
      majorAxisEndPoint: map['majorAxisEndPoint'],
      extrusionDirection: map['extrusionDirection'],
      axisRatio: map['axisRatio'],
      startAngle: map['startAngle'],
      endAngle: map['endAngle'],
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

final defaultEllipseEnitty = <String, dynamic>{
  'extrusionDirection': const Point3D(0, 0, 1),
};

final ellipseEntityParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [42],
    name: 'endAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'startAngle',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'axisRatio',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [11],
    name: 'majorAxisEndPoint',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'center',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class EllipseEntityParser implements EntityParser {
  @override
  final String forEntityName = 'ELLIPSE';

  final _parser = createParser(
    ellipseEntityParserSnippets,
    defaultEllipseEnitty,
  );

  @override
  EllipseEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return EllipseEntity.fromMap(entity);
  }
}
