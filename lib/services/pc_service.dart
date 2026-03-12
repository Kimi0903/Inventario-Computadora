import 'package:http/http.dart' as http;
import 'dart:convert';

class PcService {
  // CONFIGURACIÓN DE CONEXIÓN - AJUSTA SEGÚN TU ENTORNO:

  // Para ANDROID EMULADOR:
  // static const String baseUrl = 'http://10.0.2.2:3000';

  // Para DISPOSITIVO REAL (usa la IP de tu PC donde corre Node.js):
  //static const String baseUrl = 'http://10.39.193.107:3000';

  // Para PRUEBAS LOCALES (si el backend está en la misma PC):
  static const String baseUrl = 'http://10.10.110.25:3000';

  // ✅ RUTAS CORRECTAS para tu backend Oracle:
  static const String apiTest = '$baseUrl/api/test';
  static const String apiEquipos = '$baseUrl/api/pcs';

  // Headers comuness
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // 1. Probar conexión con el backend y Oracle
  static Future<Map<String, dynamic>> probarConexion() async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.parse(apiTest), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'Conexión establecida',
          'data': data,
          'mysql': data['mysql'] ?? {},
        };
      } else {
        return {
          'success': false,
          'message': 'Error HTTP ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'suggestion':
            'Verifica: 1) Backend corriendo, 2) IP correcta, 3) Puerto 3000 libre',
      };
    }
  }

  // 2. Guardar PC en Oracle Database
  static Future<Map<String, dynamic>> guardarPcEnServidor(
    Map<String, dynamic> pcData,
  ) async {
    // Transformar nombres de campo para coincidir con el backend
    final datosTransformados = {
      'ubicacion': pcData['ubicacion'] ?? '',
      'responsable': pcData['responsable'] ?? '',
      'puesto': pcData['puesto'],
      'tipoEquipo': pcData['tipoEquipo'], // Nota: diferente nombre
      'marca': pcData['marca'],
      'numeroSerie': pcData['numeroSerie'],
      'discoDuro': pcData['discoDuro'],
      'memoriaRam': pcData['memoriaRam'],
      'windows': pcData['windows'],
      'tarjetaGrafica': pcData['tarjetaGrafica'],
      'contrasena': pcData['contrasena'],
      'correoInstitucional': pcData['correoInstitucional'],
      'clave': pcData['clave'],
    };

    try {
      final client = http.Client();
      final response = await client
          .post(
            Uri.parse(apiEquipos),
            headers: headers,
            body: jsonEncode(datosTransformados),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return {
          'success': result['success'] ?? true,
          'message': result['message'] ?? 'PC guardada exitosamente',
          'data': result,
          'id': result['id'],
          'rowsAffected': result['rowsAffected'],
        };
      } else if (response.statusCode == 400) {
        // Error de validación
        final result = jsonDecode(response.body);
        return {
          'success': false,
          'message': result['message'] ?? 'Datos inválidos',
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
          'body': response.body,
          'statusCode': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
        'error': e.toString(),
        'suggestion':
            'Verifica la conexión de red y que el backend esté corriendo',
      };
    }
  }

  // 3. Obtener todas las PCs desde Oracle
  static Future<Map<String, dynamic>> obtenerEquipos() async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.parse(apiEquipos), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return {
          'success': result['success'] ?? true,
          'message': result['message'] ?? 'Datos obtenidos',
          'data': result['data'] ?? [],
          'count': result['count'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'Error HTTP ${response.statusCode}',
          'statusCode': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e', 'data': []};
    }
  }

  // 4. Método de prueba completa
  static Future<Map<String, dynamic>> pruebaCompleta() async {
    final conexion = await probarConexion();

    if (!conexion['success']) {
      return {
        'success': false,
        'message': 'No se pudo conectar al backend',
        'details': conexion,
      };
    }

    // Paso 2: Obtener equipos actuales
    final equiposActuales = await obtenerEquipos();

    // Paso 3: Crear nuevo equipo de prueba
    final equipoPrueba = {
      'ubicacion': 'Prueba Flutter ${DateTime.now().millisecondsSinceEpoch}',
      'responsable': 'Usuario Prueba',
      'marca': 'HP',
      'numeroSerie': 'TEST-${DateTime.now().millisecondsSinceEpoch}',
      'discoDuro': '512GB SSD',
      'memoriaRam': '8GB',
    };

    final resultadoGuardado = await guardarPcEnServidor(equipoPrueba);

    // Paso 4: Verificar que se agregó
    final equiposFinales = await obtenerEquipos();

    final resumen = {
      'success': resultadoGuardado['success'],
      'message': resultadoGuardado['success']
          ? '✅ PRUEBA COMPLETADA EXITOSAMENTE'
          : '❌ PRUEBA FALLÓ',
      'detalles': {
        'conexion': conexion['success'],
        'equipos_iniciales': equiposActuales['count'] ?? 0,
        'equipos_finales': equiposFinales['success']
            ? equiposFinales['count']
            : 'N/A',
        'equipo_creado': resultadoGuardado['success'],
        'id_nuevo': resultadoGuardado['id'],
      },
      'timestamp': DateTime.now().toIso8601String(),
    };

    return resumen;
  }

  // 5. Método para obtener un equipo específico por ID
  static Future<Map<String, dynamic>> obtenerEquipoPorId(int id) async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.parse('$apiEquipos/$id'), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return {'success': result['success'] ?? true, 'data': result['data']};
      } else {
        return {'success': false, 'message': 'Error ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // 6. Versión SIMPLIFICADA sin client() - para versiones antiguas
  static Future<Map<String, dynamic>> guardarPcSimple(
    Map<String, dynamic> pcData,
  ) async {
    // Transformar nombres de campo

    try {
      final response = await http.post(
        Uri.parse(apiEquipos),
        headers: headers,
        body: jsonEncode(pcData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);
        return {
          'success': true,
          'message': result['message'] ?? 'PC guardada',
          'data': result,
        };
      } else {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
