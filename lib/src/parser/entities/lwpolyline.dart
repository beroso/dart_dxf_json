import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/ensure_handle.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

enum LWPolylineFlag {
  isClosed(1),
  plineGen(128);

  final int code;

  const LWPolylineFlag(this.code);
}

class LWPolylineEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num? numberOfVertices;
  final num flag;
  final num? constantWidth;
  final num elevation;
  final num thickness;
  final Point3D extrusionDirection;
  final List<LWPolylineVertex> vertices;

  LWPolylineEntity({
    this.subclassMarker = 'AcDbPolyline',
    this.numberOfVertices,
    required this.flag,
    this.constantWidth,
    required this.elevation,
    required this.thickness,
    required this.extrusionDirection,
    this.vertices = const [],
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
  }) : super(type: 'LWPOLYLINE');

  factory LWPolylineEntity.fromMap(Map<String, dynamic> map) {
    return LWPolylineEntity(
      subclassMarker: map['subclassMarker'] ?? 'AcDbPolyline',
      numberOfVertices: map['numberOfVertices'],
      flag: map['flag'],
      constantWidth: map['constantWidth'],
      elevation: map['elevation'],
      thickness: map['thickness'],
      extrusionDirection: map['extrusionDirection'],
      vertices: List.from(map['vertices']),
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

class LWPolylineVertex extends Point2D {
  final num? id;
  final num? startWidth;
  final num? endWidth;
  final num bulge;

  LWPolylineVertex({
    required num x,
    required num y,
    this.id,
    this.startWidth,
    this.endWidth,
    required this.bulge,
  }) : super(x, y);

  factory LWPolylineVertex.fromMap(Map<String, dynamic> map) {
    return LWPolylineVertex(
      x: map['x'],
      y: map['y'],
      id: map['id'],
      startWidth: map['startWidth'],
      endWidth: map['endWidth'],
      bulge: map['bulge'],
    );
  }
}

final defaultLWPolylineEntity = <String, dynamic>{
  'flag': 0,
  'elevation': 0,
  'thickness': 0,
  'extrusionDirection': const Point3D(0, 0, 1),
  'vertices': <LWPolylineVertex>[],
};

final defaultLWPolylineVertex = <String, dynamic>{
  'bulge': 0,
};

final lWPolylineVertexSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [42],
    name: 'bulge',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [41],
    name: 'endWidth',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [40],
    name: 'startWidth',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [91],
    name: 'id',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [20],
    name: 'y',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'x',
    parser: identity,
  ),
];

final _lWPolylineVertexParser =
    createParser(lWPolylineVertexSnippets, defaultLWPolylineVertex);

final lWPolylineSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [10],
    name: 'vertices',
    isMultiple: true,
    parser: (curr, scanner, _) {
      final entity = <String, dynamic>{};
      _lWPolylineVertexParser(curr, scanner, entity);
      return LWPolylineVertex.fromMap(entity);
    },
  ),
  DXFParserSnippet(
    code: [39],
    name: 'thickness',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [38],
    name: 'elevation',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [43],
    name: 'constantWidth',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [70],
    name: 'flag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [90],
    name: 'numberOfVertices',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class LWPolylineParser implements EntityParser {
  @override
  final String forEntityName = 'LWPOLYLINE';

  final _parser = createParser(lWPolylineSnippets, defaultLWPolylineEntity);

  @override
  LWPolylineEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return LWPolylineEntity.fromMap(entity);
  }
}
