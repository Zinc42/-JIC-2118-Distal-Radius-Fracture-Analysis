class Coordinate {
   double x;
   double y;
   Coordinate({required this.x, required this.y});

   UpdateCordinate(int deltax, int deltay, double scalarX, double scalarY) {
     x += (deltax * scalarX).round();
     y += (deltay * scalarY).round();
   }
}