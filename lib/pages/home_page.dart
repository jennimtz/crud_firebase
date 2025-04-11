import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Especies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed:
                () => showSearch(
                  context: context,
                  delegate: SpeciesSearchDelegate(FirebaseFirestore.instance),
                ),
          ),
        ],
      ),
      body: Column(
        children: [_buildSearchBar(), Expanded(child: _buildSpeciesList())],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
        tooltip: 'Agregar especie',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar especie...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed:
                        () => setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        }),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildSpeciesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('especies').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No hay especies disponibles",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "Use el botón + para añadir una nueva especie",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        var species = snapshot.data!.docs;
        if (_searchQuery.isNotEmpty) {
          species =
              species.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                String nombre = data['nombre'] ?? '';
                String tipo = data['especie'] ?? '';
                return nombre.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    tipo.toLowerCase().contains(_searchQuery.toLowerCase());
              }).toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: species.length,
          itemBuilder: (context, index) {
            var data = species[index].data() as Map<String, dynamic>;
            return _buildSpeciesCard(data, species[index].id);
          },
        );
      },
    );
  }

  Widget _buildSpeciesCard(Map<String, dynamic> data, String docId) {
    final String nombre = data['nombre'] ?? 'Sin nombre';
    final String tamano = data['tamaño'] ?? 'Desconocido';
    final String edad = data['edad'] ?? 'Desconocida';
    final String peso = data['peso'] ?? 'Desconocido';
    final String especieTipo = data['especie'] ?? 'Desconocida';

    final Map<String, Color> colorMap = {
      'camarón': Colors.pinkAccent,
      'tilapia': Colors.blueAccent,
      'bagre': Colors.purpleAccent,
      'langostino': Colors.orangeAccent,
    };
    final Color cardColor = (colorMap[especieTipo.toLowerCase()] ?? Colors.teal)
        .withOpacity(0.2);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cardColor, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSpeciesDetails(context, data, docId),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      especieTipo,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _infoItem(Icons.straighten, 'Tamaño', tamano),
                  _infoItem(Icons.calendar_today, 'Edad', edad),
                  _infoItem(Icons.monitor_weight, 'Peso', peso),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSpeciesDetails(
    BuildContext context,
    Map<String, dynamic> data,
    String docId,
  ) {
    final fieldMap = {
      'Nombre': 'nombre',
      'Tipo': 'especie',
      'Tamaño': 'tamaño',
      'Edad': 'edad',
      'Peso': 'peso',
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.pets, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text('Detalles de ${data['nombre'] ?? 'la especie'}'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:
                  fieldMap.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data[entry.value] ?? 'Desconocido',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _confirmDeleteSpecies(context, docId),
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteSpecies(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de eliminar esta especie? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                try {
                  await FirebaseFirestore.instance
                      .collection('especies')
                      .doc(docId)
                      .delete();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Especie eliminada correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SpeciesSearchDelegate extends SearchDelegate<String> {
  final FirebaseFirestore firestore;

  SpeciesSearchDelegate(this.firestore);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(child: Text('Ingrese un término de búsqueda'));
    }

    return FutureBuilder<QuerySnapshot>(
      future:
          firestore
              .collection('especies')
              .where('nombre', isGreaterThanOrEqualTo: query)
              .where('nombre', isLessThanOrEqualTo: query + '\uf8ff')
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron resultados para "$query"',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var data = doc.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['nombre'] ?? 'Sin nombre'),
              subtitle: Text(data['especie'] ?? 'Especie desconocida'),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  (data['nombre'] as String? ?? 'S')[0].toUpperCase(),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              onTap: () => close(context, doc.id),
            );
          },
        );
      },
    );
  }
}
