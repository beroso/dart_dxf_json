import 'auto_cad_color_index.dart';
import 'dxf_iterable.dart';

/// Returns the truecolor value of the given AutoCad color index value.
int getAcadColor(int index) => autoCadColorIndex[index];

/// Some entities may contain embedded object which is started by group 101.
/// All the rest data until end of entity should not be interpreted as entity
/// attributes. There is no documentation for this feature.
void skipEmbeddedObject(DxfIterator scanner) {
  // Ensure proper start group.
  scanner.rewind();
  var curr = scanner.next();
  if (curr.code != 101) {
    throw Exception('Bad call for skipEmbeddedObject()');
  }
  do {
    curr = scanner.next();
  } while (curr.code != 0);
  scanner.rewind();
}
