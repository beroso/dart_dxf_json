class Point2D {
  final num x;
  final num y;

  const Point2D({required this.x, required this.y});
}

class Point3D {
  final num x;
  final num y;
  final num z;

  const Point3D({required this.x, required this.y, required this.z});
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
