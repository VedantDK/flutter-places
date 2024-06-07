import 'dart:io';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/models/place.dart';

class AddPlaceScreen extends ConsumerStatefulWidget{
  const AddPlaceScreen({super.key});
  
  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredPlace = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      ref.read(userPlacesProvider.notifier).addPlace(_enteredPlace, _selectedImage!, _selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    label: const Text('Title'),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty || 
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPlace = value!;
                  },
                ),
                const SizedBox(height: 10),
                ImageInput(
                  onPickImage: (image) {
                  _selectedImage = image;
                  },
                ),
                const SizedBox(height: 10),
                LocationInput(
                  onSelectLocation: (location) {
                    _selectedLocation = location;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _savePlace, 
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}