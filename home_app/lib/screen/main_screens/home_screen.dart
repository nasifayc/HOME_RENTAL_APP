import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/house.dart';
import 'package:home_app/model/house_model.dart';
import 'package:home_app/states/house_state.dart';
import 'package:home_app/widget/home/popular_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedChipIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<HouseCubit>(context).fetchHouses();
    super.initState();
  }

  final categories = [
    'All',
    'Condominium',
    'Apartments',
    'Office',
    'Villas',
    'Penthouses',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return BlocBuilder<HouseCubit, HouseState>(
      builder: (context, state) {
        if (state is HouseLoaded) {
          List<HouseModel> filteredProducts = state.houses;
          if (selectedChipIndex != 0) {
            filteredProducts = state.houses.where((product) {
              return product.category == categories[selectedChipIndex!];
            }).toList();
          }

          List<HouseModel> searchList = filteredProducts.where((product) {
            return product.title
                .toLowerCase()
                .contains(_searchController.text.trim().toLowerCase());
          }).toList();

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SearchBar(controller: _searchController),
                      const SizedBox(height: 20),
                      SectionTitle(title: 'Categories', theme: theme),
                      const SizedBox(height: 10),
                      CategoryChips(
                        categories: categories,
                        selectedIndex: selectedChipIndex,
                        onChipSelected: (index) {
                          setState(() {
                            selectedChipIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SectionTitle(title: 'Popular', theme: theme),
                      const SizedBox(height: 10),
                      PopularSectionList(houses: searchList),
                      const SizedBox(height: 25),
                      SectionTitle(title: 'For Rent', theme: theme),
                      const SizedBox(height: 10),
                      PopularSectionList(
                        houses: searchList
                            .where((house) => !house.forRent)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) => {
        context.findAncestorStateOfType<_HomeScreenState>()?.setState(() {})
      },
      decoration: InputDecoration(
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 115, 113, 113)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey.shade700),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
          filled: true,
          fillColor: const Color.fromARGB(255, 241, 241, 241),
          contentPadding: EdgeInsets.all(0),
          isDense: true),
      cursorColor: Colors.grey.shade700,
      style: TextStyle(color: Colors.grey.shade700),
    );
  }
}

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final int? selectedIndex;
  final Function(int?) onChipSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(categories.length, (int index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onChipSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black
                    : const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final AppTheme theme;

  const SectionTitle({super.key, required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.typography.titleMedium.copyWith(color: theme.primary),
    );
  }
}

class PopularSectionList extends StatelessWidget {
  final List<HouseModel> houses;

  const PopularSectionList({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: PopularSection(houses: houses),
    );
  }
}
