import '../dxf_iterable.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';

enum VertexFlag {
  createdByCurveFit(1),
  tangentDefined(2),
  notUsed(4),
  createdBySplineFit(8),
  splineControlPoint(16),
  forPolyline(32),
  forPolygon(64),
  polyface(128);

  const VertexFlag(this.code);

  final int code;

  static VertexFlag parse(int code) => values.firstWhere((e) => e.code == code);
}

class VertexEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num startWidth;
  final num endWidth;
  final num bulge;
  final VertexFlag? flag;
  final num? tangentDirection;
  final num? polyfaceIndex0;
  final num? polyfaceIndex1;
  final num? polyfaceIndex2;
  final num? polyfaceIndex3;
  final num? id;

  // TODO: extends Point3D
  final num? x;
  final num? y;
  final num? z;

  VertexEntity({
    this.subclassMarker = 'AcDb2dVertex | AcDb3dPolylineVertex',
    required this.startWidth,
    required this.endWidth,
    required this.bulge,
    this.flag,
    this.tangentDirection,
    this.polyfaceIndex0,
    this.polyfaceIndex1,
    this.polyfaceIndex2,
    this.polyfaceIndex3,
    this.id,
    this.x,
    this.y,
    this.z,
    // From [CommonDxfEntity]
    required super.handle,
    required super.layer,
  }) : super(type: 'VERTEX');

  factory VertexEntity.fromMap(Map<String, dynamic> map) {
    return VertexEntity(
      subclassMarker:
          map['subclassMarker'] ?? 'AcDb2dVertex | AcDb3dPolylineVertex',
      startWidth: map['startWidth'],
      endWidth: map['endWidth'],
      bulge: map['bulge'],
      flag: map['flag'] is VertexFlag
          ? map['flag']
          : VertexFlag.parse(map['flag']),
      tangentDirection: map['tangentDirection'],
      polyfaceIndex0: map['polyfaceIndex0'],
      polyfaceIndex1: map['polyfaceIndex1'],
      polyfaceIndex2: map['polyfaceIndex2'],
      polyfaceIndex3: map['polyfaceIndex3'],
      id: map['id'],
      x: map['x'],
      y: map['y'],
      z: map['z'],
      handle: map['handle'] ?? '', // TODO: default workaround value? ''
      layer: map['layer'] ?? '', // TODO: default workaround value? ''
      // TODO: other CommonDxfEntity types
    );
  }

  @override
  String toString() {
    return {
      'type': type,
      'subclassMarker': subclassMarker,
      'x': x,
      'y': y,
      'z': z,
    }.toString();
  }
}

const defaultVertexEntity = <String, dynamic>{
  'startWidth': 0,
  'endWidth': 0,
  'bulge': 0,
};

final lista = Iterable.generate(10);

final vertextParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [91],
    name: 'id',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [71, 72, 73, 74, 75],
    name: 'faces',
    isMultiple: true,
    parser: identity,
  ),
  DXFParserSnippet(
    code: [50],
    name: 'tangentDirection',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [70],
    name: 'flag',
    parser: identity,
  ),
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
    code: [30],
    name: 'z',
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
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [100], // skip for AcDbVertex
  ),
  ...commonEntitySnippets,
];

class VertexParser implements EntityParser {
  @override
  final forEntityName = 'VERTEX';
  final _parser = createParser(vertextParserSnippets, defaultVertexEntity);

  @override
  CommonDxfEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return VertexEntity.fromMap(entity);
  }
}
