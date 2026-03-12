import 'dart:convert';
import 'acceso_correo.dart';

class Pc {
  final int? id;
  final String ubicacion;
  final String responsable;
  final String tipoEquipo;
  final String puesto;
  final String marca;
  final String numeroSerie;
  final String discoDuro;
  final String memoriaRam;
  final String windows;
  final String tarjetaGrafica;
  final String clave;
  final List<AccesoCorreo> accesos;

  Pc({
    this.id,
    required this.ubicacion,
    required this.responsable,
    required this.puesto,
    required this.tipoEquipo,
    required this.marca,
    required this.numeroSerie,
    required this.discoDuro,
    required this.memoriaRam,
    required this.windows,
    required this.tarjetaGrafica,
    required this.accesos,
    required this.clave,
  });

  /// 🔹 DESDE SHAREDPREFERENCES
  factory Pc.fromSharedPrefsJson(Map<String, dynamic> json) {
    return Pc(
      id: json['id'],
      ubicacion: json['ubicacion'] ?? '',
      responsable: json['responsable'] ?? '',
      puesto: json['puesto'] ?? '',
      tipoEquipo: json['tipoEquipo'] ?? '',
      marca: json['marca'] ?? '',
      numeroSerie: json['numeroSerie'] ?? '',
      discoDuro: json['discoDuro'] ?? '',
      memoriaRam: json['memoriaRam'] ?? '',
      windows: json['windows'] ?? '',
      tarjetaGrafica: json['tarjetaGrafica'] ?? '',
      clave: json['clave'] ?? '',
      accesos: (json['accesos'] as List<dynamic>? ?? [])
          .map((e) => AccesoCorreo.fromJson(e))
          .toList(),
    );
  }

  /// 🔹 PARA GUARDAR (SharedPreferences / Backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ubicacion': ubicacion,
      'responsable': responsable,
      'puesto': puesto,
      'tipoEquipo': tipoEquipo,
      'marca': marca,
      'numeroSerie': numeroSerie,
      'discoDuro': discoDuro,
      'memoriaRam': memoriaRam,
      'windows': windows,
      'tarjetaGrafica': tarjetaGrafica,
      'clave': clave,
      'accesos': accesos.map((a) => a.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory Pc.fromJsonString(String jsonString) =>
      Pc.fromSharedPrefsJson(jsonDecode(jsonString));
}
