import 'package:flutter/material.dart';
//Temporary class to store some data about where the point in the images native resolution would be

class Coordinate {
   double x;
   double y;
   Coordinate({required this.x, required this.y});

   //Function updates the stored coordinate data by adding the change in x and y when moving the dragable object on screen
   //Now this update function makes sure that the offset doesnt push the coordinate out of bounds
   UpdateCordinate(Offset offset, double scalarX, double scalarY, int nativeResWidth, int nativeResHeight) {
     //Changing x and y coord by offset * scalar
     double tempX = x + (offset.dx * scalarX).round();
     double tempY = y + (offset.dy * scalarY).round();


     //Checking to make sure that coordinate with offset change is in bounds
     if (tempX > nativeResWidth) {
       x = nativeResWidth.toDouble();
     } else if (tempX < 0) {
       x = 0;
     } else {
       x = tempX;
     }

     if (tempY > nativeResHeight) {
       y = nativeResHeight.toDouble();
     } else if (tempY < 0) {
       y = 0;
     } else {
       y = tempY;
     }

   }
}