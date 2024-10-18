import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EquipmentCard extends StatefulWidget {
  final int columnCount;
  final String title;
  final String description;
  final String imageUrl;
  final int count;

  const EquipmentCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.count,
    this.columnCount = 6,
  });

  @override
  EquipmentCardState createState() => EquipmentCardState();
}

class EquipmentCardState extends State<EquipmentCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const margin = 24.0;
    const gutter = 16.0;
    const totalGutterWidth = gutter * 5; // 6개의 컬럼 사이에 5개의 거터
    const totalMarginWidth = margin * 2;
    final availableWidth = screenWidth - totalMarginWidth - totalGutterWidth;
    final columnWidth = availableWidth / 6;
    final buttonWidth =
        columnWidth * widget.columnCount + gutter * (widget.columnCount - 1);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: grayscaleSwatch[100]!,
            width: 3,
          ),
        ),
        width: buttonWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(7)), // 굵기 만큼 빼야함
              child: Image.network(
                widget.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AutoSizeText(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                  Expanded(child: Container()),
                  AutoSizeText(
                    "${widget.count}개",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: grayscaleSwatch[100],
                ),
                maxLines: 1,
                minFontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EquipmentGrid extends StatelessWidget {
  final List<Map<String, dynamic>> equipmentList;

  EquipmentGrid({required this.equipmentList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 한 줄에 두 개의 카드
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3 / 4.2, // 카드의 가로 세로 비율
      ),
      itemCount: equipmentList.length,
      itemBuilder: (context, index) {
        final equipment = equipmentList[index];
        return EquipmentCard(
          title: equipment['title']!,
          description: equipment['description']!,
          imageUrl: equipment['imageUrl']!,
          count: equipment['count']!,
        );
      },
    );
  }
}
