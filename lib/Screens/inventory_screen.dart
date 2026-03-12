import 'package:flutter/material.dart';
import 'package:inventario_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_pc_screen.dart';
import 'pc.dart';
import 'dart:io';
import 'pc_detail_screen.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import '../services/notification_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Pc> pcs = [];

  @override
  void initState() {
    super.initState();
    _cargarPcs();
    _pedirPermisoNotificaciones();
  }

  Future<void> _pedirPermisoNotificaciones() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Pc? pcSeleccionada;

  Future<void> _cargarPcs() async {
    final prefs = await SharedPreferences.getInstance();
    final pcList = prefs.getStringList('pcs') ?? [];

    if (!mounted) return;

    setState(() {
      pcs
        ..clear()
        ..addAll(pcList.map((pcJson) => Pc.fromJsonString(pcJson)));
    });
  }

  Future<void> eliminarPc(Pc pc) async {
    setState(() {
      pcs.remove(pc);
    });
    await _guardarPcs();
  }

  Future<void> _guardarPcs() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (var key in keys) {
      print("Clave: $key, Valor: ${prefs.get(key)}");
    }
    final pcJsonList = pcs.map((pc) => pc.toJsonString()).toList();
    await prefs.setStringList('pcs', pcJsonList); // Ya está bien
  }

  Future<void> verPcsGuardadas() async {}
  Future<void> _exportarInventarioExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Inventario'];

      // Encabezados
      sheetObject.appendRow([
        'Ubicación',
        'Responsable',
        'Puesto',
        'Tipo Equipo',
        'Marca',
        'Número Serie',
        'Disco Duro',
        'Memoria RAM',
        'Windows',
        'Tarjeta Gráfica',
        'Clave',
        'Correos',
        'Contraseñas',
      ]);

      // Datos
      for (var pc in pcs) {
        String correos = pc.accesos.map((a) => a.correo).join(' / ');
        String contrasenas = pc.accesos.map((a) => a.contrasena).join(' / ');

        sheetObject.appendRow([
          pc.ubicacion,
          pc.responsable,
          pc.puesto,
          pc.tipoEquipo,
          pc.marca,
          pc.numeroSerie,
          pc.discoDuro,
          pc.memoriaRam,
          pc.windows,
          pc.tarjetaGrafica,
          pc.clave,
          correos,
          contrasenas,
        ]);
      }

      Directory downloadsDir = Directory('/storage/emulated/0/Download');

      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      String filePath =
          '${downloadsDir.path}/inventario_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel guardado en Descargas')),
      );

      print(' LLEGÓ A NOTIFICACIÓN');
      await mostrarNotificacionExportado();
      ultimoArchivoExportado = filePath;
      await mostrarNotificacionExportado();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Inventario de PCs'),
            Text(
              'Total: ${pcs.length}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Exportar a Excel',
            onPressed: _exportarInventarioExcel,
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: pcs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.computer_outlined,
                      size: 80,
                      color: const Color.fromARGB(
                        255,
                        3,
                        27,
                        238,
                      ).withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay PCs registradas',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pcs.length,
                itemBuilder: (_, index) => _pcCard(pcs[index]),
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: const Color(0xFF1E3A8A),
              onPressed: () async {
                final Pc? nuevaPc = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPcScreen()),
                );

                if (nuevaPc != null) {
                  setState(() => pcs.add(nuevaPc));
                  await _guardarPcs();
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> actualizarPc(int index, Pc nuevaPc) async {
    setState(() {
      pcs[index] = nuevaPc;
    });
    await _guardarPcs();
  }

  Widget _pcCard(Pc pc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            pcSeleccionada = pc;

            final Pc? pcEditada = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PcDetailScreen(pc: pc)),
            );

            if (pcEditada != null) {
              final index = pcs.indexOf(pc);
              await actualizarPc(index, pcEditada);
            }
          },

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.computer,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pc.ubicacion,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Responsable: ${pc.responsable}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Puesto: ${pc.puesto}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey.withOpacity(0.5),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    setState(() {
                      pcs.remove(pc);
                    });
                    await _guardarPcs();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
