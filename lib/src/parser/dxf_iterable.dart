import 'shared/is_matched.dart';
import 'utils.dart';

class ScannerGroup {
  final int code;
  final Object? value;

  ScannerGroup({required this.code, required this.value});
}

class DxfIterator implements Iterator<ScannerGroup> {
  ScannerGroup _current;
  int _pointer;
  bool _eof;
  final List<String> _data;

  DxfIterator(List<String> dxfLines)
      : _data = dxfLines,
        _eof = false,
        _pointer = 0,
        _current = ScannerGroup(code: 0, value: 0);

  @override
  ScannerGroup get current => _current;

  @override
  bool moveNext() {
    if (!hasNext()) {
      _current = ScannerGroup(code: 0, value: 'EOF');
      return false;
    }

    final code = int.parse(_data[_pointer++]);
    final value = parseGroupValue(code, _data[_pointer++]);
    final group = ScannerGroup(code: code, value: value);

    if (isMatched(group, 0, 'EOF')) {
      _eof = true;
    }

    _current = group;

    return true;
  }

  ScannerGroup next() {
    moveNext();
    return _current;
  }

  void rewind([int numberOfGroups = 1]) {
    _pointer = _pointer - numberOfGroups * 2;
  }

  bool hasNext() {
    if (_eof) return false;
    if (_pointer > _data.length - 2) return false;

    return true;
  }
}
