import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gps_camera/screens/camera.dart';
import 'package:gps_camera/screens/map.dart'; // Importa la clase CameraDescription

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<void> _cameraInitialization;
  CameraDescription? _firstCamera;

  @override
  void initState() {
    super.initState();
    _cameraInitialization = _initializeFirstCamera();
  }

  Future<void> _initializeFirstCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        _firstCamera = cameras.first;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cámara no disponible'),
          content: const Text(
              'No se encontraron cámaras disponibles en este dispositivo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Menú de opciones',
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
        backgroundColor: const Color.fromARGB(255, 255, 68, 68),
    ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<void>(
          future: _cameraInitialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                _firstCamera != null) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Mapa'),
                    leading: const Icon(
                      Icons.map_outlined,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) => const MapaScreen(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                  ListTile(
                    title: const Text('Fotografía'),
                    leading: const Icon(
                      Icons.photo_camera_back_outlined,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      final route = MaterialPageRoute(
                        builder: (context) =>
                            const RegistrarProyecto(),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}