import '../../types.dart';
import '../dxf_iterable.dart';

Point3D parsePoint(DxfIterator scanner) {
  num pointX = 0, pointY = 0, pointZ = 0;

  // Reread group for the first coordinate
  scanner.rewind();
  var curr = scanner.next();
  final firstCode = curr.code;
  pointX = curr.value as num;
  curr = scanner.next();

  if (curr.code != firstCode + 10) {
    throw Exception(
      'Expected code for point value to be 20 but got ${curr.code}.',
    );
  }
  pointY = curr.value as num;
  curr = scanner.next();
  if (curr.code != firstCode + 20) {
    // Only the x and y are specified. Don't read z.
    scanner.rewind(); // Let the calling code advance off the point
    return Point3D(x: pointX, y: pointY, z: 0);
  }
  pointZ = curr.value as num;

  return Point3D(x: pointX, y: pointY, z: pointZ);
}
