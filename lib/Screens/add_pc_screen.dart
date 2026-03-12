import 'package:flutter/material.dart';
import 'acceso_correo.dart';
import 'pc.dart'; // Ajusta la ruta según tu proyecto

class AddPcScreen extends StatefulWidget {
  const AddPcScreen({super.key});

  @override
  State<AddPcScreen> createState() => _AddPcScreenState();
}

class _AddPcScreenState extends State<AddPcScreen> {
  final ubicacionCtrl = TextEditingController();
  final responsableCtrl = TextEditingController();
  final puestoCtrl = TextEditingController();
  final tipodeEquipoCtrl = TextEditingController();
  final marcaCtrl = TextEditingController();
  final numeroSerieCtrl = TextEditingController();
  final discoDuroCtrl = TextEditingController();
  final memoriaRamCtrl = TextEditingController();
  final windowsCtrl = TextEditingController();
  final tarjetaGraficaCtrl = TextEditingController();
  // final contrasenaCtrl = TextEditingController();
  //final correoInstitucionalCtrl = TextEditingController();
  final claveCtrl = TextEditingController();
  List<TextEditingController> correos = [];
  List<TextEditingController> contrasenas = [];
  @override
  void dispose() {
    ubicacionCtrl.dispose();
    responsableCtrl.dispose();
    puestoCtrl.dispose();
    tipodeEquipoCtrl.dispose();
    marcaCtrl.dispose();
    numeroSerieCtrl.dispose();
    discoDuroCtrl.dispose();
    memoriaRamCtrl.dispose();
    windowsCtrl.dispose();
    tarjetaGraficaCtrl.dispose();
    // contrasenaCtrl.dispose();
    //correoInstitucionalCtrl.dispose();
    claveCtrl.dispose();
    super.dispose();
    for (var correo in correos) {
      correo.dispose();
    }
    for (var contrasena in contrasenas) {
      contrasena.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _agregarCorreos();
  }

  void _agregarCorreos() {
    setState(() {
      correos.add(TextEditingController());
      contrasenas.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar PC'),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(ubicacionCtrl, 'Ubicación', Icons.location_on),
              _buildTextField(responsableCtrl, 'Responsable', Icons.person),
              _buildTextField(puestoCtrl, 'Puesto', Icons.work),
              _buildTextField(tipodeEquipoCtrl, 'Tipo de Equipo', Icons.layers),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'EQUIPO DE CÓMPUTO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(marcaCtrl, 'Marca', Icons.build),
              _buildTextField(
                numeroSerieCtrl,
                'Número de Serie (N.S)',
                Icons.tag,
              ),
              _buildTextField(discoDuroCtrl, 'Disco Duro (D.D)', Icons.storage),
              _buildTextField(memoriaRamCtrl, 'Memoria RAM', Icons.memory),
              _buildTextField(windowsCtrl, 'Windows', Icons.window),
              _buildTextField(claveCtrl, 'Clave', Icons.lock),
              _buildTextField(
                tarjetaGraficaCtrl,
                'Tarjeta Gráfica',
                Icons.videogame_asset,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'INFORMACIÓN DE ACCESO',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: 1,
                ),
              ),
              // ===== LISTA DINÁMICA DE CORREOS =====
              Column(
                children: List.generate(correos.length, (index) {
                  return Column(
                    children: [
                      _buildTextField(
                        correos[index],
                        'Correo institucional ${index + 1}',
                        Icons.email,
                      ),
                      _buildTextField(
                        contrasenas[index],
                        'Contraseña ${index + 1}',
                        Icons.lock,
                        // isPassword: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              correos[index].dispose();
                              contrasenas[index].dispose();
                              correos.removeAt(index);
                              contrasenas.removeAt(index);
                            });
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                }),
              ),

              TextButton.icon(
                onPressed: _agregarCorreos,
                icon: const Icon(Icons.add),
                label: const Text('Agregar otro correo'),
              ),

              _buildTextField(claveCtrl, 'Clave', Icons.vpn_key),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _guardarPc,
                    child: const Text(
                      'Agregar PC',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 14),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF1E3A8A).withOpacity(0.6),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0F2FE),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE0F2FE),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _guardarPc() {
    if (ubicacionCtrl.text.isEmpty || responsableCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, completa los campos requeridos"),
        ),
      );
      return;
    }

    final List<AccesoCorreo> accesos = [];

    for (int i = 0; i < correos.length; i++) {
      if (correos[i].text.isNotEmpty && contrasenas[i].text.isNotEmpty) {
        accesos.add(
          AccesoCorreo(
            correo: correos[i].text,
            contrasena: contrasenas[i].text,
          ),
        );
      }
    }

    final Pc nuevaPc = Pc(
      ubicacion: ubicacionCtrl.text,
      responsable: responsableCtrl.text,
      puesto: puestoCtrl.text,
      tipoEquipo: tipodeEquipoCtrl.text,
      marca: marcaCtrl.text,
      numeroSerie: numeroSerieCtrl.text,
      discoDuro: discoDuroCtrl.text,
      memoriaRam: memoriaRamCtrl.text,
      windows: windowsCtrl.text,
      tarjetaGrafica: tarjetaGraficaCtrl.text,
      clave: claveCtrl.text,
      // contrasena: contrasenaCtrl.text,
      // correoInstitucional: correoInstitucionalCtrl.text,
      accesos: accesos,
    );

    Navigator.pop(context, nuevaPc);
  }
}
