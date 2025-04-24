import 'package:car_black_box/views/navigation_bar_pages/favourite_palces/place.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class FavouritePalcesScreen extends StatefulWidget {
  const FavouritePalcesScreen({super.key});

  @override
  State<FavouritePalcesScreen> createState() => _FavouritePalcesScreenState();
}

class _FavouritePalcesScreenState extends State<FavouritePalcesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _addPlace() async {
    final name = _nameController.text;
    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (name.isNotEmpty && lat != null && lng != null) {
      final place = Place(name: name, latitude: lat, longitude: lng);
      final box = Hive.box<Place>('favoritePlaces');
      await box.add(place);

      // Clear input fields
      _nameController.clear();
      _latController.clear();
      _lngController.clear();

      // Close the dialog
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid name, latitude, and longitude')),
      );
    }
  }

  void _showAddPlaceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Favorite Place'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Place Name'),
            ),
            TextField(
              controller: _latController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addPlace,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Edit the name of an existing place
  void _editPlaceName(int index, Place place) async {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Place Name'),
        content: TextField(
          controller: editNameController,
          decoration: const InputDecoration(labelText: 'Place Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = editNameController!.text;
              if (newName.isNotEmpty) {
                place.name = newName;
                await place.save(); // Update the place in Hive
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid name')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Place>('favoritePlaces').listenable(),
        builder: (context, Box<Place> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No favorite places yet!'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final place = box.getAt(index)!;
              return ListTile(
                title: Text(place.name),
                leading: const Icon(Icons.favorite_outlined, color: Colors.red,),
                subtitle: Text('Added on: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        _editPlaceName( index, place);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await box.deleteAt(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlaceDialog,
        tooltip: 'Add manually',
        child: const Icon(Icons.add),
      ),
    );
  }
}
