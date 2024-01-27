import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


enum NotificationColor { red, green, blue }

// ========== return Notification color ========== //

Color getNotificationColor(NotificationColor color) {
  switch (color) {
    case NotificationColor.red:
      return Colors.red;
    case NotificationColor.green:
      return Colors.green;
    case NotificationColor.blue:
      return Colors.blue;
    default:
      return Colors.transparent;
  }
}
