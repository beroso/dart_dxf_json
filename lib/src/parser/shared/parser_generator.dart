import '../dxf_iterable.dart';
import 'is_matched.dart';
import 'parse_point.dart';

const abort = Object();

typedef ParserFunction = Object? Function(
  ScannerGroup curr,
  DxfIterator scanner,
  Map<String, dynamic> entity,
);

class DXFParserSnippet {
  DXFParserSnippet({
    required this.code,
    this.name,
    this.parser,
    this.isMultiple = false,
    this.pushContext = false,
  });

  final List<int> code;
  final String? name;

  final ParserFunction? parser;

  final bool isMultiple;

  // https://github.com/connect-for-you/cadview-front/issues/41
  final bool pushContext;
}

typedef DXFParser = bool Function(
  ScannerGroup curr,
  DxfIterator scanner,
  Map<String, dynamic> target,
);

DXFParser createParser(
  List<DXFParserSnippet> snippets,
  Map<String, dynamic>? defaultObject,
) {
  return (curr, scanner, target) {
    final snippetMaps = createSnippetMaps(snippets);
    var isReadOnce = false;
    var contextIndex = snippetMaps.length - 1;

    while (!isMatched(curr, 0, 'EOF')) {
      final snippetMap = findSnippetMap(
        snippetMaps,
        curr.code,
        contextIndex,
      );
      final snippet = snippetMap?[curr.code]?.last;

      if (snippetMap == null || snippet == null) {
        scanner.rewind();
        break;
      }

      if (!snippet.isMultiple) {
        snippetMap[curr.code]!.removeLast();
      }

      final name = snippet.name;
      final parser = snippet.parser;
      final isMultiple = snippet.isMultiple;

      final parsedValue = parser?.call(curr, scanner, target);

      if (parsedValue == abort) {
        scanner.rewind();
        break;
      }

      if (name != null) {
        final (leaf, fieldName) = getObjectByPath(target, name);

        if (isMultiple) {
          if (leaf[fieldName] == null) {
            leaf[fieldName] = [];
          }
          leaf[fieldName].add(parsedValue);
        } else {
          leaf[fieldName] = parsedValue;
        }
      }

      if (snippet.pushContext) {
        contextIndex -= 1;
      }

      isReadOnce = true;
      curr = scanner.next();
    }

    if (defaultObject != null) {
      for (final k in defaultObject.keys) {
        if (!target.containsKey(k)) {
          target[k] = defaultObject[k];
        }
      }
    }

    return isReadOnce;
  };
}

List<Map<int, List<DXFParserSnippet>>> createSnippetMaps(
  List<DXFParserSnippet> snippets,
) {
  final map = <Map<int, List<DXFParserSnippet>>>[{}];
  for (final snippet in snippets) {
    if (snippet.pushContext) {
      map.add({});
    }

    final context = map.last;

    for (final code in snippet.code) {
      final bin = (context[code] ??= []);
      if (snippet.isMultiple && bin.isNotEmpty) {
        // TODO: just debug print instead of throwing exception
        throw Exception(
          'Snippet ${bin.last.name} for code($code) is shadowed by ${snippet.name}',
        );
      }
      bin.add(snippet);
    }
  }
  return map;
}

Map<int, List<DXFParserSnippet>>? findSnippetMap(
  List<Map<int, List<DXFParserSnippet>>> snippetMaps,
  int code,
  int contextIndex,
) {
  for (final (index, map) in snippetMaps.indexed) {
    if (index >= contextIndex && (map[code]?.isNotEmpty ?? false)) {
      return map;
    }
  }

  return null;
}

(Map<String, dynamic>, String) getObjectByPath(
  Map<String, dynamic> target,
  String path,
) {
  final fragments = path.split('.');

  var currentTarget = target;
  for (int depth = 0; depth < fragments.length - 1; ++depth) {
    var currentName = fragments[depth];
    if (currentTarget[currentName] == null) {
      currentTarget[currentName] = {};
    }
    currentTarget = currentTarget[currentName];
  }
  return (currentTarget, fragments.last);
}

ParserFunction identity = (curr, _, __) => curr.value;

ParserFunction pointParser = (_, scanner, __) => parsePoint(scanner);

ParserFunction toBoolean = (curr, _, __) => curr.value as int == 1;
