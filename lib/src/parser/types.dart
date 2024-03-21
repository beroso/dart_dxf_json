import 'blocks/blocks.dart';
import 'entities/shared.dart';

class ParsedDxf {
  final Map<String, dynamic> header = {};
  final Map<String, DxfBlock> blocks = {};
  final List<CommonDxfEntity> entities = [];
}
