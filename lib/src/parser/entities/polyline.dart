import '../../types.dart';
import '../dxf_iterable.dart';
import '../shared/is_matched.dart';
import '../shared/parser_generator.dart';
import 'shared.dart';
import 'vertex.dart';

enum PolylineFlag {
  closedPolyline(1),
  curveFit(2),
  splineFit(4),
  polyline3D(8),
  polygon3D(16),
  closedPolygon(32),
  polyface(64),
  continuous(128);

  const PolylineFlag(this.code);

  final int code;
}

enum SmoothType {
  none(0),
  quadratic(5),
  cubic(6),
  bezier(8);

  const SmoothType(this.code);

  final int code;
}

class PolylineEntity extends CommonDxfEntity {
  final String subclassMarker;
  final num? thickness;
  final num? flag;
  final num? startWidth;
  final num? endWidth;
  final num? meshMVertexCount;
  final num? meshNVertexCount;
  final num? surfaceMDensity;
  final num? surfaceNDensity;
  final SmoothType? smoothType;
  final Point3D? extrusionDirection;
  final List<VertexEntity>? vertices;

  const PolylineEntity({
    this.subclassMarker = 'AcDb2dPolyline | AcDb3dPolyline',
    this.thickness,
    this.flag,
    this.startWidth,
    this.endWidth,
    this.meshMVertexCount,
    this.meshNVertexCount,
    this.surfaceMDensity,
    this.surfaceNDensity,
    this.smoothType,
    this.extrusionDirection,
    this.vertices,
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
  }) : super(type: 'POLYLINE');

  factory PolylineEntity.fromMap(Map<String, dynamic> map) {
    return PolylineEntity(
      subclassMarker:
          map['subclassMarker'] ?? 'AcDb2dPolyline | AcDb3dPolyline',
      thickness: map['thickness'],
      flag: map['flag'],
      startWidth: map['startWidth'],
      endWidth: map['endWidth'],
      meshMVertexCount: map['meshMVertexCount'],
      meshNVertexCount: map['meshNVertexCount'],
      surfaceMDensity: map['surfaceMDensity'],
      surfaceNDensity: map['surfaceNDensity'],
      smoothType: map['smoothType'],
      extrusionDirection: map['extrusionDirection'],
      vertices: List.from(map['vertices']),
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

  @override
  String toString() {
    return {
      'type': type,
      'subclassMarker': subclassMarker,
      'vertices': vertices,
    }.toString();
  }
}

const defaultPolylineEntity = <String, dynamic>{
  'thickness': 0,
  'flag': 0,
  'startWidth': 0,
  'endWidth': 0,
  'meshMVertexCount': 0,
  'meshNVertexCount': 0,
  'surfaceMDensity': 0,
  'surfaceNDensity': 0,
  'smoothType': SmoothType.none,
  'extrusionDirection': Point3D(0, 0, 1),
  'vertices': <VertexEntity>[],
};

final polylineParserSnippets = <DXFParserSnippet>[
  DXFParserSnippet(
    code: [0],
    name: 'vertices',
    isMultiple: true,
    parser: (curr, scanner, entity) {
      if (!isMatched(curr, 0, 'VERTEX')) return abort;
      curr = scanner.next();
      return VertexParser().parseEntity(scanner, curr);
    },
  ),
  DXFParserSnippet(
    code: [210],
    name: 'extrusionDirection',
    parser: pointParser,
  ),
  DXFParserSnippet(
    code: [75],
    name: 'smoothType',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [74],
    name: 'surfaceNDensity',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [73],
    name: 'surfaceMDensity',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [72],
    name: 'meshNVertexCount',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [71],
    name: 'meshMVertexCount',
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
    code: [70],
    name: 'flag',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [39],
    name: 'thickness',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [30],
    name: 'elevation',
    parser: identity,
  ),
  DXFParserSnippet(
    code: [20], // dummy point, always 0
  ),
  DXFParserSnippet(
    code: [10], // dummy point, always 0
  ),
  DXFParserSnippet(
    code: [66], // obsolete, ignore
  ),
  DXFParserSnippet(
    code: [100],
    name: 'subclassMarker',
    parser: identity,
  ),
  ...commonEntitySnippets,
];

class PolylineParser implements EntityParser {
  @override
  final String forEntityName = 'POLYLINE';
  final _parser = createParser(
    polylineParserSnippets,
    defaultPolylineEntity,
  );

  @override
  CommonDxfEntity parseEntity(DxfIterator scanner, ScannerGroup curr) {
    final entity = <String, dynamic>{};
    _parser(curr, scanner, entity);
    return PolylineEntity.fromMap(entity);
  }
}
