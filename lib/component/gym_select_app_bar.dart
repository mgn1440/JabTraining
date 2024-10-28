import 'package:flutter/material.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/provider/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jab_training/pages/gym_select_page.dart';

class GymSelectAppBar extends StatelessWidget implements PreferredSizeWidget {
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    late LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    void selectGymLocation(BuildContext context) async {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const GymSelectPage()),
      );

      if (result != null && result is String) {
        prefs = await SharedPreferences.getInstance();
        await prefs.setString('centerName', result);
        locationProvider.updateCurrentLocation(result);
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(54),
      child: AppBar(
        backgroundColor: background,
        scrolledUnderElevation: 0,
        title: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: grayscaleSwatch[100],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          locationProvider.currentLocation,
                          style: TextStyle(
                            color: grayscaleSwatch[100],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CustomButton(
                  //   isEnabled: true,
                  //   buttonType: ButtonType.text,
                  //   onPressed: () async => selectGymLocation(context),
                  //   columnCount: 1,
                  //   child: const Text('바꾸기'),
                  // )
                  TextButton(
                      onPressed: () => selectGymLocation(context),
                      child: Text(
                        '바꾸기',
                        style: TextStyle(
                          color: primarySwatch[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
