import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/house.dart';
import 'package:home_app/states/house_state.dart';
import 'package:image_picker/image_picker.dart';

class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({super.key});

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  bool _forRent = false;
  double _bedrooms = 1;
  double _bathrooms = 1;
  double _floors = 1;

  File? _mainImage;
  List<File> _subImages = [];

  Future<void> _pickMainImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _mainImage = File(image!.path);
    });
  }

  Future<void> _pickSubImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        // Convert each XFile to File and add to _subImages
        _subImages.addAll(images.map((xfile) => File(xfile.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final _ = BlocProvider.of<HouseCubit>(context);
    final categories = [
      'Apartments',
      'Villas',
      'Studios',
      'Townhouses',
      'Penthouses',
      'Duplexes',
      'Others'
    ];
    final houseCubit = BlocProvider.of<HouseCubit>(context);

    return BlocConsumer<HouseCubit, HouseState>(listener: (context, state) {
      if (state is HouseAdded) {
        _titleController.clear();
        _locationController.clear();
        _descriptionController.clear();
        _priceController.clear();

        setState(() {
          _bedrooms = 1;
          _bathrooms = 1;
          _floors = 1;
          _selectedCategory = null;
          _mainImage = null;
          _subImages = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("House Added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a title" : null,
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      labelText: "Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a location" : null,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a description" : null,
                  ),
                  const SizedBox(height: 16),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter a price" : null,
                  ),
                  const SizedBox(height: 25),

                  DropdownButtonFormField<String>(
                    value: _selectedCategory, // Bind the selected category
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    hint: const Text("Select a category"), // Placeholder hint
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory =
                            value; // Update state with the selected category
                      });
                    },
                    validator: (value) =>
                        value == null ? "Please select a category" : null,
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildNumberPicker(
                          theme: theme,
                          label: "Bedrooms",
                          value: _bedrooms.toInt(),
                          onChanged: (value) =>
                              setState(() => _bedrooms = value.toDouble()),
                        ),
                      ),
                      Expanded(
                        child: _buildNumberPicker(
                          theme: theme,
                          label: "Bathrooms",
                          value: _bathrooms.toInt(),
                          onChanged: (value) =>
                              setState(() => _bathrooms = value.toDouble()),
                        ),
                      ),
                      Expanded(
                        child: _buildNumberPicker(
                          theme: theme,
                          label: "Floors",
                          value: _floors.toInt(),
                          onChanged: (value) =>
                              setState(() => _floors = value.toDouble()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // For Rent Toggle
                  ListTile(
                    title: Text(
                      "For Rent",
                      style: theme.typography.headlineSmall,
                    ),
                    trailing: Switch(
                      activeColor: theme.primary,
                      inactiveTrackColor: theme.tertiary,

                      // trackColor: const WidgetStatePropertyAll(Colors.black),
                      thumbColor: const WidgetStatePropertyAll(Colors.white),
                      value: _forRent,
                      onChanged: (value) {
                        setState(() {
                          _forRent = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Picker
                  Text(
                    "Main Image",
                    style: theme.typography.headlineSmall,
                  ),
                  GestureDetector(
                    onTap: _pickMainImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _mainImage == null
                          ? const Center(
                              child: Icon(Icons.add_a_photo,
                                  size: 40, color: Colors.black))
                          : Image.file(
                              File(_mainImage!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Images",
                            style: theme.typography.headlineSmall,
                          ),
                          GestureDetector(
                            onTap: _pickSubImages,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Sub Images Picker Button

                      const SizedBox(height: 16),

                      // Sub Images Preview
                      _buildSubImagesPreview(theme: theme),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<HouseCubit, HouseState>(
                        builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          print("submitted");
                          if (_formKey.currentState!.validate()) {
                            houseCubit.addHouse(
                                _titleController.text,
                                _locationController.text,
                                _descriptionController.text,
                                num.parse(_priceController.text),
                                _selectedCategory!,
                                _bedrooms,
                                _bathrooms,
                                _floors,
                                _forRent,
                                _mainImage!,
                                _subImages.map((image) => image).toList());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: state is! HouseLoading
                            ? Text(
                                "Submit",
                                style: theme.typography.labelSmall,
                              )
                            : const CircularProgressIndicator(),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

// Replace this method:
  Widget _buildNumberPicker(
      {required String label,
      required int value,
      required Function(int) onChanged,
      required AppTheme theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: $value",
          style: theme.typography.bodySmall,
        ),
        CustomNumberPicker(
          initialValue: value,
          maxValue: 10,
          minValue: 1,
          step: 1,
          valueTextStyle: theme.typography.bodySmall,
          onValue: (num newValue) => onChanged(newValue as int),
        ),
      ],
    );
  }

  Widget _buildSubImagesPreview({required AppTheme theme}) {
    return _subImages.isEmpty
        ? Text(
            "No sub images selected",
            style: theme.typography.bodySmall,
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _subImages.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.file(
                        File(image.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _subImages.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
  }
}
