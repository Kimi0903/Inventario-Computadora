class AccesoCorreo {
  final String correo;
  final String contrasena;

  AccesoCorreo({required this.correo, required this.contrasena});

  Map<String, dynamic> toJson() => {'correo': correo, 'contrasena': contrasena};

  factory AccesoCorreo.fromJson(Map<String, dynamic> json) {
    return AccesoCorreo(
      correo: json['correo'] ?? '',
      contrasena: json['contrasena'] ?? '',
    );
  }
}
