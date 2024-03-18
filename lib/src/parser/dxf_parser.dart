import 'dart:convert';

import 'dxf_iterable.dart';
import 'entities/entities.dart';
import 'shared/is_matched.dart';
import 'types.dart';

class DxfParserOptions {
  final Encoding encoding;

  const DxfParserOptions({
    this.encoding = utf8,
  });
}

class DfxParser {
  final DxfParserOptions options;

  Encoding get encoding => options.encoding;

  DfxParser({this.options = const DxfParserOptions()});

  ParsedDxf parseString(String dxfString) {
    final lines = const LineSplitter().convert(dxfString.trim());
    return _parseAll(lines);
  }

  ParsedDxf _parseAll(List<String> lines) {
    final dxf = ParsedDxf();

    final scanner = DxfIterator(lines);

    var current = scanner.current;

    while (!isMatched(current, 0, 'EOF')) {
      if (isMatched(current, 0, 'SECTION')) {
        current = scanner.next();

        if (isMatched(current, 2, 'HEADER')) {
          current = scanner.next();
          // dxf.header = parseHeader(curr, scanner);
        } else if (isMatched(current, 2, 'BLOCKS')) {
          current = scanner.next();
          // dxf.blocks = parseBlocks(current, scanner);
        } else if (isMatched(current, 2, 'ENTITIES')) {
          current = scanner.next();
          dxf.entities.addAll(parseEntities(current, scanner));
        } else if (isMatched(current, 2, 'TABLES')) {
          current = scanner.next();
          // dxf.tables = parseTables(current, scanner);
        } else if (isMatched(current, 2, 'OBJECTS')) {
          current = scanner.next();
          // dxf.objects = parseObjects(current, scanner);
        }
      }
      current = scanner.next();
    }

    return dxf;
  }
}
