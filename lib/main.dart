import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'Screens/login_screen.dart';
import 'Screens/inventory_screen.dart';
import 'Screens/add_pc_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔔 Canal de notificaciones
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'export_channel',
  'Exportación Inventario',
  description: 'Inventario Exportado en Descargas',
  importance: Importance.max,
);

/// 📂 Ruta del último archivo exportado
String? ultimoArchivoExportado;

/// 🔔 Plugin global
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔔 Configuración Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  /// 🍎 Configuración iOS
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  /// ✅ INICIALIZAR UNA SOLA VEZ (MUY IMPORTANTE)
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final String? path = response.payload;

      debugPrint('📂 Payload recibido: $path');

      if (path != null && path.isNotEmpty) {
        final result = await OpenFilex.open(path);
        debugPrint('📂 Resultado OpenFilex: ${result.message}');
      }
    },
  );

  /// ✅ CREAR CANAL DESPUÉS DE INITIALIZE
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  runApp(const MyApp());
}

/// 🔔 Mostrar notificación con payload
Future<void> mostrarNotificacionExportado() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'export_channel',
    'Exportaciones',
    channelDescription: 'Notificaciones de exportación',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Exportación completa',
    'El archivo se exportó correctamente',
    details,
    payload: ultimoArchivoExportado,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario PC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 151, 184, 245),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/add': (context) => const AddPcScreen(),
      },
    );
  }
}
