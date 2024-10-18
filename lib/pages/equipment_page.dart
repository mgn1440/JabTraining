import 'package:flutter/material.dart';
import 'package:jab_training/component/gym_select_app_bar.dart';
import 'package:jab_training/component/equipment_card.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/provider/gym_equipment_provider.dart';
import 'package:jab_training/provider/location_provider.dart';
import 'package:provider/provider.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  GymEquipmentsProvider gymEquipmentsProvider = GymEquipmentsProvider(supabase);
  final locationProvider = LocationProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GymSelectAppBar(),
      body: Center(
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return FutureBuilder<List<dynamic>>(
              future: gymEquipmentsProvider
                  .getEquipmentsData(locationProvider.currentLocationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No facilities available.');
                } else {
                  final equipments = snapshot.data!;
                  return EquipmentGrid(
                    equipmentList: equipments
                        .where((equipment) =>
                            equipment['gym_type'] ==
                            locationProvider.currentLocationId)
                        .map((equipment) {
                      return {
                        'title': equipment['title'],
                        'description': equipment['description'],
                        'imageUrl': equipment['imageUrl'],
                        'count': equipment['count'],
                      };
                    }).toList(),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
