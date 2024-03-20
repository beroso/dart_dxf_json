class Point3D {
  final num x;
  final num y;
  final num z;

  const Point3D(this.x, this.y, [this.z = 0]);
}

class Bound {
  final num minX;
  final num minY;
  final num maxX;
  final num maxY;

  const Bound({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });
}

// export type MakeOptional<T, K extends keyof T> = Omit<T, K> &
//     Partial<Pick<T, K>>;

// export type Indexed<T, P extends string> = {
//     [key in P]: T;
// } & {
//     index: number;
// };
