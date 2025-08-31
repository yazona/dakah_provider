import 'dart:convert';

import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_states.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/add_new_halls/allow_smoking_bar_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/add_new_halls/image_gallery_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddNewHallScreen extends StatelessWidget {
  const AddNewHallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var locationController = TextEditingController();
    var hallNameARController = TextEditingController();
    var hallNameENController = TextEditingController();
    var billiardHourPriceController = TextEditingController();
    var balootHourPriceController = TextEditingController();
    var chessHourPriceController = TextEditingController();
    var workingTimeController = TextEditingController();
    var addressController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<HallsCubit, HallsStates>(
      listener: (context, state) {
        if (state is AddNewHallSuccessState) {
          Navigator.pop(context);
          HallsCubit.get(context).getHalls(fromPagination: false);
          AppFunctions.buildSnackBar(
            context,
            text: 'hallAddedSuccessfully'.tr(),
            icon: Icons.verified,
            showCloseIcon: true,
          );
        }
      },
      builder: (context, state) {
        var cubit = HallsCubit.get(context);
        return PopScope(
          onPopInvoked: (didPop) {
            cubit.userPickedLocationMarker.clear();
            cubit.hallImages.clear();
            cubit.userPickedLocation = null;
            cubit.changeAllowSmoking(false);
          },
          child: Scaffold(
            body: state is AddNewHallLoadingState
                ? const CustomLoading()
                : BodyWithAppHeader(
                    fromHome: false,
                    appBar: CustomAppBar(
                      rightType: ButtonAppBarType.none,
                      leftType: ButtonAppBarType.backButton,
                      title: '- ${'addNewHall'.tr()} -',
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: hallNameARController,
                              hintText: 'hallNameAR'.tr(),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: AlignmentDirectional.center,
                                  decoration: const BoxDecoration(
                                    color: ColorsManager.kPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AssetsManager.kHallNameIconSVG,
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsManager.kWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseEnterHallNameAR'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: hallNameENController,
                              hintText: 'hallNameEN'.tr(),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: AlignmentDirectional.center,
                                  decoration: const BoxDecoration(
                                    color: ColorsManager.kPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AssetsManager.kHallNameIconSVG,
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsManager.kWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseEnterHallNameEN'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: phoneController,
                              hintText: 'phoneNumber'.tr(),
                              prefixIconSVGPath: AssetsManager.kPhoneIconSVG,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseEnterPhoneNumber'.tr();
                                } else if (!value.startsWith('05')) {
                                  return 'phoneNumberMustStartWith05'.tr();
                                } else if (value.length != 10) {
                                  return 'pleaseEnterValidPhoneNumber'.tr();
                                } else if (int.tryParse(value) == null) {
                                  return 'pleaseEnterValidPhoneNumber'.tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              hintText: 'billiardHourPrice'.tr(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseSpecifyHourlyRate'.tr();
                                }
                                return null;
                              },
                              controller: billiardHourPriceController,
                              prefixIconSVGPath:
                                  AssetsManager.kHourPriceIconSVG,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              hintText: 'balootHourPrice'.tr(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseSpecifyHourlyRate'.tr();
                                }
                                return null;
                              },
                              controller: balootHourPriceController,
                              prefixIconSVGPath:
                                  AssetsManager.kHourPriceIconSVG,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              hintText: 'chessHourPrice'.tr(),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseSpecifyHourlyRate'.tr();
                                }
                                return null;
                              },
                              controller: chessHourPriceController,
                              prefixIconSVGPath:
                                  AssetsManager.kHourPriceIconSVG,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: workingTimeController,
                              readOnly: true,
                              onTap: () async {
                                var startTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: 'chooseStartTime'.tr());
                                if (startTime != null) {
                                  if (context.mounted) {
                                    var endTime = await showTimePicker(
                                      context: context,
                                      initialTime: startTime,
                                      helpText: 'chooseEndTime'.tr(),
                                    );
                                    if (endTime != null) {
                                      workingTimeController.text =
                                          '${'${'from'.tr()} ${startTime.hour}:${startTime.minute}'} ${'${'to'.tr()} ${endTime.hour}:${endTime.minute}'}';
                                    }
                                  }
                                }
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseSpecifyWorkingHours'.tr();
                                }
                                return null;
                              },
                              hintText: 'workTime'.tr(),
                              prefixIconSVGPath: AssetsManager.kClockIconVG,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: addressController,
                              hintText: 'address'.tr(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseEnterTheAddress'.tr();
                                }
                                return null;
                              },
                              prefixIconSVGPath: AssetsManager.kLocationSVG,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: locationController,
                              readOnly: true,
                              onTap: () {
                                AppFunctions.buildAppDialog(
                                  allowCloseWithBackButton: true,
                                  context,
                                  child: ChooseLocationDialog(
                                    textController: locationController,
                                  ),
                                );
                              },
                              prefixIconSVGPath: AssetsManager.kLocationIconSVG,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseChooseHallLocation'.tr();
                                }
                                return null;
                              },
                              hintText: 'location'.tr(),
                            ),
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                    AssetsManager.kAddImageIconSVG,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'addImages'.tr(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ImageGallery(
                              cubit: cubit,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AllowSmokingRadioBar(cubit: cubit),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (cubit.hallImages.isEmpty) {
                                    AppFunctions.buildSnackBar(
                                      context,
                                      text: 'atLeastOnImageMustBeAdded'.tr(),
                                      backgroundColor: ColorsManager.kRed,
                                      icon: Icons.error,
                                    );
                                    return;
                                  }
                                  cubit.addNewHall(
                                    lat: cubit.userPickedLocation!.latitude,
                                    long: cubit.userPickedLocation!.longitude,
                                    nameAR: hallNameARController.text.trim(),
                                    nameEN: hallNameENController.text.trim(),
                                    billiardPrice: billiardHourPriceController.text.trim(),
                                    chessPrice: chessHourPriceController.text.trim(),
                                    balootPrice: balootHourPriceController.text.trim(),
                                    phone: phoneController.text,
                                    startTime: workingTimeController.text
                                        .split(' ')[1],
                                    endTime: workingTimeController.text
                                        .split(' ')[3],
                                    address: addressController.text.trim(),
                                  );
                                }
                              },
                              title: 'save'.tr(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class ChooseLocationDialog extends StatelessWidget {
  const ChooseLocationDialog({super.key, required this.textController});

  final TextEditingController textController;

  void saveLocation(List<LatLng> list, LatLng location) {
    if (list.contains(location)) return;
    if (list.length < 5) {
      list.add(location);
    } else {
      list.removeLast();
      list.add(location);
    }
    List<Map<String, double>> mapList = list
        .map((element) => {'lat': element.latitude, 'lng': element.longitude})
        .toList();
    Map<String, dynamic> fullMap = {'points': mapList};
    String jsonString = jsonEncode(fullMap);
    CacheHelper.saveData(key: 'savedAddress', value: jsonString);
  }

  List<LatLng> loadSavedAddresses() {
    String? jsonString = CacheHelper.getData(key: 'savedAddress');
    if (jsonString != null) {
      Map<String, dynamic> fullMap = jsonDecode(jsonString);
      List<dynamic> pointList = fullMap['points'];
      return pointList.map((item) => LatLng(item['lat'], item['lng'])).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> savedAddresses = loadSavedAddresses();
    return BlocConsumer<HallsCubit, HallsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HallsCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'chooseYourLocation'.tr(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    buildingsEnabled: false,
                    mapToolbarEnabled: false,
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(23.885942, 45.079163), zoom: 5),
                    onTap: (argument) {
                      cubit.pickUserLocation(argument);
                    },
                    onMapCreated: (controller) async {
                      LocationPermission permission =
                          await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        Geolocator.requestPermission();
                      }
                    },
                    markers: cubit.userPickedLocationMarker,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            cubit.userPickedLocation = savedAddresses[index];
                            textController.text =
                                '${cubit.userPickedLocation!.latitude} ${cubit.userPickedLocation!.longitude}';
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            height: 50,
                            width: 80,
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                                color: ColorsManager.kPrimaryColor
                                    .withValues(alpha: .5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.black.withValues(alpha: .3))),
                            child: Text(
                              '${savedAddresses[index].latitude.round()}, ${savedAddresses[index].longitude.round()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 10,
                        ),
                    itemCount: savedAddresses.length),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'accept'.tr(),
                      onPressed: () {
                        if (cubit.userPickedLocation != null) {
                          saveLocation(
                              savedAddresses, cubit.userPickedLocation!);
                          textController.text =
                              '${cubit.userPickedLocation!.latitude} ${cubit.userPickedLocation!.longitude}';
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: ColorsManager.kWhite,
                      borderColor: ColorsManager.kPrimaryColor,
                      fontColor: ColorsManager.kPrimaryColor,
                      title: 'cancel'.tr(),
                      onPressed: () {
                        cubit.userPickedLocationMarker.clear();
                        cubit.userPickedLocation = null;
                        textController.clear();
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
