import '../../types.dart';
import '../dxf_iterable.dart';
import '../entities/entities.dart';
import '../entities/shared.dart';
import '../shared/ensure_handle.dart';
import '../shared/is_matched.dart';
import '../shared/parse_point.dart';

class DxfBlock {
  final num? type; // bit flag of BlockTypeFlag
  final String? name;
  final String? name2;
  final String? handle;
  final String? ownerHandle;
  final String? layer;
  final Point3D? position;
  final bool? paperSpace;
  final String? xrefPath;
  final List<CommonDxfEntity> entities;

  DxfBlock({
    this.type,
    this.name,
    this.name2,
    this.handle,
    this.ownerHandle,
    this.layer,
    this.position,
    this.paperSpace,
    this.xrefPath,
    this.entities = const [],
  });

  factory DxfBlock.fromMap(Map<String, dynamic> map) {
    return DxfBlock(
      type: map['type'],
      name: map['name'],
      name2: map['name2'],
      handle: map['handle'],
      ownerHandle: map['ownerHandle'],
      layer: map['layer'],
      position: map['position'],
      paperSpace: map['paperSpace'],
      xrefPath: map['xrefPath'],
      entities: map['entities'] ?? [],
    );
  }
}

Map<String, DxfBlock> parseBlocks(
  ScannerGroup curr,
  DxfIterator scanner,
) {
  final blocks = <String, Map<String, dynamic>>{};

  while (!isMatched(curr, 0, 'EOF')) {
    if (isMatched(curr, 0, 'ENDSEC')) {
      break;
    }

    if (isMatched(curr, 0, 'BLOCK')) {
      curr = scanner.next();
      final block = parseBlock(curr, scanner);

      block['handle'] = ensureHandle(block['handle']);
      if (block['name'] != null) {
        blocks[block['name']] = block;
      }
    }

    curr = scanner.next();
  }
  return {
    for (final entry in blocks.entries)
      entry.key: DxfBlock.fromMap(entry.value),
  };
}

Map<String, dynamic> parseBlock(ScannerGroup curr, DxfIterator scanner) {
  final block = <String, dynamic>{};

  while (!isMatched(curr, 0, 'EOF')) {
    if (isMatched(curr, 0, 'ENDBLK')) {
      // 당장 ENDBLK 파싱이 없어서 임시로 대충 소비함
      // 소비 안하면 ENTITY에 딸려들어가서 문제 생김
      curr = scanner.next();
      while (!isMatched(curr, 0, 'EOF')) {
        if (isMatched(curr, 100, 'AcDbBlockEnd')) {
          return block;
        }
        curr = scanner.next();
      }
      break;
    }

    switch (curr.code) {
      case 1:
        block['xrefPath'] = curr.value;
        break;
      case 2:
        block['name'] = curr.value;
        break;
      case 3:
        block['name2'] = curr.value;
        break;
      case 5:
        block['handle'] = curr.value;
        break;
      case 8:
        block['layer'] = curr.value;
        break;
      case 10:
        block['position'] = parsePoint(scanner);
        break;
      case 67:
        block['paperSpace'] = curr.value == 1 ? true : false;
        break;
      case 70:
        if (curr.value != 0) {
          block['type'] = curr.value;
        }
        break;
      case 100:
        // ignore class markers
        break;
      case 330:
        block['ownerHandle'] = curr.value;
        break;
      case 0:
        block['entities'] = parseEntities(curr, scanner);
        break;
    }

    curr = scanner.next();
  }
  return block;
}
