import '../dxf_iterable.dart';
import '../shared/is_matched.dart';
import '../shared/parse_point.dart';

Map<String, dynamic> parseHeader(ScannerGroup curr, DxfIterator scanner) {
  // interesting variables:
  //  $ACADVER, $VIEWDIR, $VIEWSIZE, $VIEWCTR, $TDCREATE, $TDUPDATE
  // http://www.autodesk.com/techpubs/autocad/acadr14/dxf/header_section_al_u05_c.htm
  // Also see VPORT table entries
  String currVarName = '';
  final header = <String, dynamic>{};

  while (!isMatched(curr, 0, 'EOF')) {
    if (isMatched(curr, 0, 'ENDSEC')) {
      break;
    }

    if (curr.code == 9) {
      currVarName = curr.value as String;
    } else if (curr.code == 10) {
      header[currVarName] = parsePoint(scanner);
    } else {
      header[currVarName] = curr.value;
    }
    curr = scanner.next();
  }
  return header;
}
