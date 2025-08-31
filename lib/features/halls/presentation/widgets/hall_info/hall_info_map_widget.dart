import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HallInfoMap extends StatelessWidget {
  const HallInfoMap({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(HallsCubit.get(context).hallInfo.lat,
                  HallsCubit.get(context).hallInfo.long),
              zoom: 14,
              bearing: 0,
              tilt: 0),
          markers: {
            Marker(
              markerId: MarkerId(
                  HallsCubit.get(context).hallInfo.id.toString()),
              position: LatLng(HallsCubit.get(context).hallInfo.lat,
                  HallsCubit.get(context).hallInfo.long),
            )
          },
        ),
      ),
    );
  }
}
