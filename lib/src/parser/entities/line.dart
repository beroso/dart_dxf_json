import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

class LineEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num? thickness;
  final Point3D? startPoint;
  final Point3D? endPoint;
  final Point3D? extrusionDirection;

  const LineEntity({
    this.subclassMarker = 'AcDbLine',
    this.thickness,
    this.startPoint,
    this.endPoint,
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
  }) : super(type: 'LINE');

  factory LineEntity.fromMap(Map<String, dynamic> map) {
    return LineEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbLine',
      thickness: map['thickness'],
      startPoint: map['startPoint'],
      endPoint: map['endPoint'],
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

const defaultLineEntity = {
  'thickness': 0,
  'extrusionDirection': Point3D(0, 0, 1),
};

final lineEntityParserSnippets = <DXFParserSnippet>[
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

class LineEntityParser implements EntityParser {
  @override
  String forEntityName = 'LINE';

  final _parser = createParser(lineEntityParserSnippets, defaultLineEntity);

  @override
  CommonDxfEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return LineEntity.fromMap({
      ...entity,
      'handle': ensureHandle(entity['handle']),
    });
  }
}
