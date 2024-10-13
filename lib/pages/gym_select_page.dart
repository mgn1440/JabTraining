import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jab_training/const/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/pages/sign_up_page.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class GymSelectPage extends StatefulWidget {
  const GymSelectPage({super.key});

  @override
  GymSelectSatate createState() => GymSelectSatate();
}

class GymSelectSatate extends State<GymSelectPage>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;
  late String centerName = '';
  bool isDropdownVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    initPrefs();
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != 'fromSignUp') {
        setState(() {
          centerName = prefs.getString('centerName') ?? '';
        });
      }
    });
  }

  Future<void> saveCenterName(String name) async {
    await prefs.setString('centerName', name);
    setState(() {
      centerName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "지점선택", iconStat: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 105),
            GestureDetector(
              onTap: () {
                setState(() {
                  isDropdownVisible = !isDropdownVisible;
                  if (isDropdownVisible) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 51.0,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: grayscaleSwatch[100]!,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '지점을 선택해주세요',
                          style: TextStyle(
                            fontSize: 16,
                            color: grayscaleSwatch[100],
                          ),
                        ),
                      ),
                      // const Expanded(child: SizedBox()),
                      AnimatedRotation(
                        turns: isDropdownVisible ? 0.5 : 0.0, // 180도 회전
                        duration: const Duration(milliseconds: 200),
                        child: Transform.rotate(
                          angle: -90 * 3.1415927 / 180, // 90도 회전
                          child: Icon(Icons.arrow_back_ios_new,
                              color: grayscaleSwatch[100]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: SizedBox(
                height: 180.0,
                child: Column(children: _buildCenterList()),
              ),
            ),
            const Expanded(child: SizedBox()),
            CustomButton(
              isEnabled: centerName.isNotEmpty,
              buttonType: ButtonType.filled,
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args == 'fromSignUp') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  } else {
                    Navigator.pop(context, centerName);
                  }
                });
              },
              child: const Text('선택'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCenterList() {
    final centers = ['잽트레이닝 교대점', '잽트레이닝 역삼점', '잽트레이닝 선릉점'];
    return centers.map((center) {
      final isSelected = center == centerName;
      return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ListTile(
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected ? primarySwatch[500] : grayscaleSwatch[100],
              fontSize: 16,
            ),
            child: Text(center),
          ),
          trailing: CustomRadio(
            value: center,
            groupValue: centerName,
            onChanged: (value) {
              if (value != null) {
                saveCenterName(value);
              }
            },
          ),
          onTap: () {
            saveCenterName(center);
          },
        ),
      );
    }).toList();
  }
}

class CustomRadio extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: SvgPicture.asset(
          isSelected
              ? 'assets/images/selected_check.svg'
              : 'assets/images/unselected_check.svg',
          key: ValueKey<bool>(isSelected),
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
