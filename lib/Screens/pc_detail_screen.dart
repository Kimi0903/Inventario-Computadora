import 'package:flutter/material.dart';
import 'pc.dart';
import 'acceso_correo.dart';

class PcDetailScreen extends StatefulWidget {
  final Pc pc;

  const PcDetailScreen({super.key, required this.pc});

  @override
  State<PcDetailScreen> createState() => _PcDetailScreenState();
}

class _PcDetailScreenState extends State<PcDetailScreen> {
  late TextEditingController ubicacionCtrl;
  late TextEditingController responsableCtrl;
  late TextEditingController puestoCtrl;
  late TextEditingController tipoEquipoCtrl;
  late TextEditingController marcaCtrl;
  late TextEditingController numeroSerieCtrl;
  late TextEditingController discoDuroCtrl;
  late TextEditingController memoriaRamCtrl;
  late TextEditingController windowsCtrl;
  late TextEditingController tarjetaGraficaCtrl;
  late TextEditingController claveCtrl;

  List<TextEditingController> correoCtrls = [];
  List<TextEditingController> contrasenaCtrls = [];

  @override
  void initState() {
    super.initState();

    ubicacionCtrl = TextEditingController(text: widget.pc.ubicacion);
    responsableCtrl = TextEditingController(text: widget.pc.responsable);
    puestoCtrl = TextEditingController(text: widget.pc.puesto);
    tipoEquipoCtrl = TextEditingController(text: widget.pc.tipoEquipo);
    marcaCtrl = TextEditingController(text: widget.pc.marca);
    numeroSerieCtrl = TextEditingController(text: widget.pc.numeroSerie);
    discoDuroCtrl = TextEditingController(text: widget.pc.discoDuro);
    memoriaRamCtrl = TextEditingController(text: widget.pc.memoriaRam);
    windowsCtrl = TextEditingController(text: widget.pc.windows);
    tarjetaGraficaCtrl = TextEditingController(text: widget.pc.tarjetaGrafica);
    claveCtrl = TextEditingController(text: widget.pc.clave);

    // Cargar accesos existentes
    for (final acceso in widget.pc.accesos) {
      correoCtrls.add(TextEditingController(text: acceso.correo));
      contrasenaCtrls.add(TextEditingController(text: acceso.contrasena));
    }
  }

  @override
  void dispose() {
    ubicacionCtrl.dispose();

    responsableCtrl.dispose();
    puestoCtrl.dispose();
    tipoEquipoCtrl.dispose();
    marcaCtrl.dispose();
    numeroSerieCtrl.dispose();
    discoDuroCtrl.dispose();
    memoriaRamCtrl.dispose();
    windowsCtrl.dispose();
    tarjetaGraficaCtrl.dispose();
    claveCtrl.dispose();

    for (final c in correoCtrls) {
      c.dispose();
    }
    for (final c in contrasenaCtrls) {
      c.dispose();
    }

    super.dispose();
  }

  void _guardarCambios() {
    final List<AccesoCorreo> nuevosAccesos = [];

    for (int i = 0; i < correoCtrls.length; i++) {
      if (correoCtrls[i].text.isNotEmpty &&
          contrasenaCtrls[i].text.isNotEmpty) {
        nuevosAccesos.add(
          AccesoCorreo(
            correo: correoCtrls[i].text,
            contrasena: contrasenaCtrls[i].text,
          ),
        );
      }
    }

    final pcEditada = Pc(
      ubicacion: ubicacionCtrl.text,
      responsable: responsableCtrl.text,
      puesto: puestoCtrl.text,
      tipoEquipo: tipoEquipoCtrl.text,
      marca: marcaCtrl.text,
      numeroSerie: numeroSerieCtrl.text,
      discoDuro: discoDuroCtrl.text,
      memoriaRam: memoriaRamCtrl.text,
      windows: windowsCtrl.text,
      tarjetaGrafica: tarjetaGraficaCtrl.text,
      clave: claveCtrl.text,
      accesos: nuevosAccesos,
    );

    Navigator.pop(context, pcEditada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar PC'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection('INFORMACIÓN GENERAL', [
              _buildEditableRow('Ubicación', ubicacionCtrl),
              _buildEditableRow('Responsable', responsableCtrl),
              _buildEditableRow('Puesto', puestoCtrl),
              _buildEditableRow('Tipo de Equipo', tipoEquipoCtrl),
            ]),
            const SizedBox(height: 20),
            _buildSection('EQUIPO DE CÓMPUTO', [
              _buildEditableRow('Marca', marcaCtrl),
              _buildEditableRow('Número de Serie', numeroSerieCtrl),
              _buildEditableRow('Disco Duro', discoDuroCtrl),
              _buildEditableRow('Memoria RAM', memoriaRamCtrl),
              _buildEditableRow('Windows', windowsCtrl),
              _buildEditableRow(
                'Clave',
                claveCtrl,
              ), //Fue lo que agregue nuevo se me habia olvidado
              _buildEditableRow('Tarjeta Gráfica', tarjetaGraficaCtrl),
            ]),
            const SizedBox(height: 20),

            ///  SECCIÓN DE ACCESOS CORREGIDA
            _buildSection('INFORMACIÓN DE ACCESO', [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: correoCtrls.length,
                itemBuilder: (context, i) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario ${i + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildEditableRow('Correo', correoCtrls[i]),
                          _buildEditableRow('Contraseña', contrasenaCtrls[i]),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  correoCtrls[i].dispose();
                                  contrasenaCtrls[i].dispose();
                                  correoCtrls.removeAt(i);
                                  contrasenaCtrls.removeAt(i);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _guardarCambios,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEditableRow(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
