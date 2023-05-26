// categorybar.dart
import 'package:flutter/material.dart';

class CategoryBar extends StatefulWidget {
  Function(String) onCategorySelected;

  CategoryBar({required this.onCategorySelected});

  @override
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        //카테고리바는 수평방향 scroll
        children: [
          _buildCategoryOption('All'),
          _buildCategoryOption('Outer'),
          _buildCategoryOption('Top'),
          _buildCategoryOption('Bottom'),
          _buildCategoryOption('Shoes'),
          _buildCategoryOption('Acc'),
          _buildCategoryOption('NoLabel'),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String categoryName) {
    bool isSelected = categoryName == _selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryName;
        });
        widget.onCategorySelected(categoryName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: isSelected ? Border(bottom: BorderSide(width: 2, color: Colors.black)) : null,
        ),
        child: Text(
          categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

