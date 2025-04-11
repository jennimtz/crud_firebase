import 'package:flutter/material.dart';
import 'package:crud_firebase/services/firebase_service.dart'; // Asegúrarse de importar el servicio
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedSpecies = 'Camarón';
  List<String> speciesList = ['Camarón', 'Tilapia', 'Bagre', 'Langostino'];

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Función para guardar la especie en Firestore
  Future<void> _saveSpecies() async {
    String name = _nameController.text.trim();
    String size = _sizeController.text.trim();
    String age = _ageController.text.trim();
    String weight = _weightController.text.trim();
    String speciesType = _selectedSpecies;

    if (name.isNotEmpty &&
        size.isNotEmpty &&
        age.isNotEmpty &&
        weight.isNotEmpty) {
      try {
        // Llamada a la función para agregar la especie a Firestore
        await addSpecies(name, size, age, weight, speciesType);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Especie guardada exitosamente')),
        );

        // Volver a la página anterior después de guardar la especie
        Navigator.pop(context);
      } catch (e) {
        // Capturar errores y mostrar el mensaje de error
        print("Error al guardar la especie: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la especie')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese todos los campos')),
      );
    }
  }

  // Función para agregar una nueva especie
  void _addNewSpecies() async {
    String newSpecies =
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            TextEditingController speciesController = TextEditingController();
            return AlertDialog(
              title: const Text('Agregar nueva especie'),
              content: TextField(
                controller: speciesController,
                decoration: const InputDecoration(
                  hintText: 'Nombre de la especie',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, speciesController.text.trim());
                  },
                  child: const Text(
                    'Agregar',
                    style: TextStyle(color: Color.fromARGB(255, 60, 39, 176)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color.fromARGB(255, 244, 54, 155)),
                  ),
                ),
              ],
            );
          },
        ) ??
        '';

    if (newSpecies.isNotEmpty && !speciesList.contains(newSpecies)) {
      setState(() {
        speciesList.add(newSpecies);
        _selectedSpecies = newSpecies;
      });

      try {
        await FirebaseFirestore.instance.collection('species').add({
          'speciesType': newSpecies,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Especie agregada correctamente')),
        );
      } catch (e) {
        print('Error al agregar nueva especie: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al agregar nueva especie')),
        );
      }
    } else if (newSpecies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de la especie no puede estar vacío'),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('La especie ya existe')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Especie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSpecies,
                    items:
                        speciesList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSpecies = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Selecciona una especie',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewSpecies,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _sizeController,
              decoration: const InputDecoration(labelText: 'Tamaño'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Peso'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _saveSpecies,
                  child: const Text('Guardar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
