import 'dart:convert';

import 'blocks/blocks.dart';
import 'dxf_iterable.dart';
import 'entities/entities.dart';
import 'header/header.dart';
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

    var curr = scanner.current;

    while (!isMatched(curr, 0, 'EOF')) {
      if (isMatched(curr, 0, 'SECTION')) {
        curr = scanner.next();

        if (isMatched(curr, 2, 'HEADER')) {
          curr = scanner.next();
          dxf.header.addAll(parseHeader(curr, scanner));
        } else if (isMatched(curr, 2, 'BLOCKS')) {
          curr = scanner.next();
          dxf.blocks.addAll(parseBlocks(curr, scanner));
        } else if (isMatched(curr, 2, 'ENTITIES')) {
          curr = scanner.next();
          dxf.entities.addAll(parseEntities(curr, scanner));
        } else if (isMatched(curr, 2, 'TABLES')) {
          curr = scanner.next();
          // dxf.tables = parseTables(curr, scanner);
        } else if (isMatched(curr, 2, 'OBJECTS')) {
          curr = scanner.next();
          // dxf.objects = parseObjects(curr, scanner);
        }
      }
      curr = scanner.next();
    }

    return dxf;
  }
}
