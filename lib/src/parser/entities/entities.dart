import '../dxf_iterable.dart';
import '../shared/is_matched.dart';
import 'arc.dart';
import 'attdef.dart';
import 'attribute.dart';
import 'circle.dart';
import 'line.dart';
import 'mtext.dart';
import 'polyline.dart';
import 'shared.dart';
import 'text.dart';

export 'arc.dart';
export 'attdef.dart';
export 'line.dart';
export 'polyline.dart';
export 'text.dart';

final parsers = {
  for (final parser in [
    ArcEntityParser(),
    AttDefEntityParser(),
    AttributeEntityParser(),
    CircleEntityParser(),
    LineEntityParser(),
    MTextEntityParser(),
    PolylineParser(),
    TextEntityParser(),
  ])
    parser.forEntityName: parser
};

List<CommonDxfEntity> parseEntities(ScannerGroup curr, DxfIterator scanner) {
  final entities = <CommonDxfEntity>[];

  while (!isMatched(curr, 0, 'EOF')) {
    if (curr.code == 0) {
      if (curr.value == 'ENDBLK' || curr.value == 'ENDSEC') {
        scanner.rewind();
        break;
      }

      final handler = parsers[curr.value as String];
      if (handler != null) {
        curr = scanner.next();
        final entity = handler.parseEntity(scanner, curr);
        entities.add(entity);
      } else {
        // throw Exception('Unsupported ENTITY type: ${curr.value}');
      }
    }
    curr = scanner.next();
  }

  return entities;
}
