import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // usa la instancia global

Future<void> mostrarNotificacionExportacion() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'export_channel',
    'Exportación Inventario',
    channelDescription: 'Notificación al exportar inventario',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Exportación completada',
    'El inventario se exportó correctamente 📁✅',
    notificationDetails,
  );
}
