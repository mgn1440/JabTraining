import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/gym_select_app_bar.dart';
import 'package:jab_training/component/equipment_card.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GymSelectAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: EquipmentGrid(
                // descripton에 한 줄 이상 되는 문자를 넣으면 에러가 발생
                equipmentList: const [
                  {
                    'title': '덤벨 3kg x 2',
                    'description': '다양한 무게의 덤벨',
                    'imageUrl':
                        'https://m.melkinsports.com/web/product/big/202402/5a6e10a26d1d9b88e367291b2d649354.jpg',
                  },
                  {
                    'title': '러닝머신 x 2',
                    'description': '최신형 러닝머신',
                    'imageUrl':
                        'https://pama.co.kr/web/product/big/202109/5852cd81ec9e89aae24fbef3d44c10c2.png',
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
