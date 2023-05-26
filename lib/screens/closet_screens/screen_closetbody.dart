import 'package:flutter/material.dart';
import 'package:untitled/models/model_category.dart';
import 'package:untitled/models/model_clothing_item.dart';
import 'package:untitled/screens/closet_components/categorybar.dart';
import 'package:untitled/screens/closet_components/closet_controller.dart';
import 'package:untitled/screens/closet_components/clothing_grid.dart';

class ClosetBodyScreen extends StatefulWidget {
  @override
  _ClosetBodyScreenState createState() => _ClosetBodyScreenState();
}

class _ClosetBodyScreenState extends State<ClosetBodyScreen> {
  final ClosetController _controller = ClosetController();
  Category _selectedCategory = Category(name: 'All', clothingItems: []);

  @override
  void initState() {
    super.initState();
    _fetchClothingItems();
  }

  Future<void> _fetchClothingItems() async {// 선택된 카테고리에 해당하는 의류 항목들을 가져오는 역할
    List<ClothingItem> items = await _controller.fetchClothingItems(_selectedCategory.name);
    setState(() {
      _selectedCategory.clothingItems = items;//update
    });
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      _selectedCategory = _controller.getCategoryByName(categoryName);//선택된 카테고리의 name을 받음.
    });
    _fetchClothingItems();//해당 카테고리를 가져옴
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CategoryBar(
            onCategorySelected: _onCategorySelected,
          ),
          Expanded(
            child: ClothingGrid(
              clothingItems: _selectedCategory.clothingItems,
            ),
          ),
        ],
      ),
    );
  }
}
