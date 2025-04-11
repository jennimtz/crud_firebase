import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> addSpecies(
  String name,
  String size,
  String age,
  String weight,
  String speciesType,
) async {
  try {
    await db.collection('especies').add({
      'nombre': name,
      'tamaño': size,
      'edad': age,
      'peso': weight,
      'especie': speciesType,
    });
    print('Especie agregada correctamente');
  } catch (e) {
    print('Error al agregar la especie: $e');
  }
}

Future<List<Map<String, dynamic>>> getSpecies() async {
  List<Map<String, dynamic>> species = [];
  CollectionReference collectionReferenceSpecies = db.collection('especies');

  QuerySnapshot querySpecies = await collectionReferenceSpecies.get();

  print('Número de documentos obtenidos: ${querySpecies.docs.length}');

  querySpecies.docs.forEach((documento) {
    var data = documento.data() as Map<String, dynamic>;
    print('Documento: $data');

    if (data.containsKey('nombre') && data['nombre'] != null) {
      species.add(data);
    } else {
      print('Este documento no tiene un campo "nombre" válido: $data');
    }
  });

  await Future.delayed(const Duration(seconds: 2));
  return species;
}
