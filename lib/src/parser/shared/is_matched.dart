import '../dxf_iterable.dart';

bool isMatched(ScannerGroup group, num code, Object? value) {
  return group.code == code && (value == null || group.value == value);
}
