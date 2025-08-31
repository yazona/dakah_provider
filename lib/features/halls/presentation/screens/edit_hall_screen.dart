import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/halls/data/hall_model.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_states.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/add_new_halls/allow_smoking_bar_widget.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_info/custom_switch_with_title_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_new_hall_screen.dart';

class EditHallScreen extends StatelessWidget {
  const EditHallScreen({super.key, required this.model});

  final Hall model;

  @override
  Widget build(BuildContext context) {
    var locationController = TextEditingController(
        text: '${model.lat.round()}, ${model.long.round()}');
    var hallNameARController = TextEditingController();
    hallNameARController.text = model.nameAR;
    var hallNameENController = TextEditingController();
    hallNameENController.text = model.nameEN;
    var billiardPriceController = TextEditingController();
    var balootPriceController = TextEditingController();
    var chessPriceController = TextEditingController();
    billiardPriceController.text = model.billiardPrice.toString();
    balootPriceController.text = model.balootPrice.toString();
    chessPriceController.text = model.chessPrice.toString();
    var phoneController = TextEditingController();
    phoneController.text = model.phone;
    var workingTimeController = TextEditingController();
    workingTimeController.text =
        '${'from'.tr()} ${model.openTime} ${'to'.tr()} ${model.closeTime}';
    var addressController = TextEditingController();
    addressController.text = model.place;
    var formKey = GlobalKey<FormState>();
    HallsCubit.get(context).billiardBooking = model.billiardActive!;
    HallsCubit.get(context).chessBooking = model.chessActive!;
    HallsCubit.get(context).balootBooking = model.balootActive!;
    HallsCubit.get(context).allowSmoking = model.smokingAllowed;
    return BlocConsumer<HallsCubit, HallsStates>(
      listener: (context, state) {
        if (state is EditHallSuccessState) {
          Navigator.pop(context);
          HallsCubit.get(context).getHallInfo(hallID: model.id);
          HallsCubit.get(context).getHalls();
          AppFunctions.buildSnackBar(
            context,
            text: 'hallEditedSuccessfully'.tr(),
            icon: Icons.verified,
            showCloseIcon: true,
          );
        }
      },
      builder: (context, state) {
        var cubit = HallsCubit.get(context);
        return Scaffold(
          body: state is EditHallLoadingState
              ? const CustomLoading()
              : BodyWithAppHeader(
                  fromHome: false,
                  appBar: CustomAppBar(
                    rightType: ButtonAppBarType.none,
                    leftType: ButtonAppBarType.backButton,
                    title: '- ${'editHall'.tr()} -',
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
                            controller: billiardPriceController,
                            prefixIconSVGPath: AssetsManager.kHourPriceIconSVG,
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
                            controller: balootPriceController,
                            prefixIconSVGPath: AssetsManager.kHourPriceIconSVG,
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
                            controller: chessPriceController,
                            prefixIconSVGPath: AssetsManager.kHourPriceIconSVG,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                              Expanded(
                                child: Text(
                                  'images'.tr(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index < model.images.length) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 90,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF939393)),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${AppConstants.kBaseURL}${model.images[index].url}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: GestureDetector(
                                            onTap: () {
                                              cubit.deleteNetworkImage(
                                                  model.images, index);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (index <
                                    model.images.length +
                                        cubit.editHallImages.length) {
                                  final pickedIndex =
                                      index - model.images.length;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 90,
                                    width: 115,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF939393)),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(
                                              cubit.editHallImages[pickedIndex],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: GestureDetector(
                                            onTap: () {
                                              cubit.deleteNewImagesOnEditHall(
                                                  pickedIndex);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () =>
                                        cubit.pickHallImageOnEditHall(),
                                    child: Container(
                                        alignment: AlignmentDirectional.center,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 90,
                                        width: 115,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFF939393)),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                            AssetsManager.kAddImageBoxIconSVG)),
                                  );
                                }
                              },
                              itemCount: model.images.length +
                                  cubit.editHallImages.length +
                                  1,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AllowSmokingRadioBar(cubit: cubit),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomSwitchWithTitle(
                            title: 'balootBookings'.tr(),
                            switchValue: cubit.balootBooking,
                            onToggle: (value) {
                              cubit.changeBalootBookingValue(value);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomSwitchWithTitle(
                            title: 'chessBookings'.tr(),
                            switchValue: cubit.chessBooking,
                            onToggle: (value) =>
                                cubit.changeChessBookingValue(value),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomSwitchWithTitle(
                            title: 'billiardBookings'.tr(),
                            switchValue: cubit.billiardBooking,
                            onToggle: (value) =>
                                cubit.changeBilliardBookingValue(value),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            onPressed: () {
                              if (model.images.isEmpty &&
                                  cubit.editHallImages.isEmpty) {
                                AppFunctions.buildSnackBar(
                                  context,
                                  text: 'atLeastOnImageMustBeAdded'.tr(),
                                  icon: Icons.error,
                                  showCloseIcon: true,
                                  backgroundColor: ColorsManager.kRed,
                                );
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                cubit.editHall(
                                    phone: phoneController.text,
                                    nameAR: hallNameARController.text.trim(),
                                    nameEN: hallNameENController.text.trim(),
                                    billiardPrice: int.parse(
                                        billiardPriceController.text.trim()),
                                    balootPrice: int.parse(
                                        balootPriceController.text.trim()),
                                    chessPrice: int.parse(
                                        chessPriceController.text.trim()),
                                    startTime: workingTimeController.text
                                        .split(' ')[1],
                                    endTime: workingTimeController.text
                                        .split(' ')[3],
                                    address: addressController.text.trim(),
                                    hallID: model.id,
                                    location: LatLng(model.lat, model.long));
                              }
                            },
                            title: 'edit'.tr(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget getImagesWidget(HallsCubit cubit) {
    if (cubit.editHallImages.isEmpty) {
      return GestureDetector(
        onTap: () => cubit.pickHallImageOnEditHall(),
        child: Container(
          alignment: AlignmentDirectional.center,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 90,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF939393)),
              color: ColorsManager.kWhite,
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(AssetsManager.kAddImageBoxIconSVG),
        ),
      );
    } else {
      return Row(
        children: List.generate(
          cubit.editHallImages.length,
          (index) => Expanded(
            child: Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 90,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF939393)),
                  color: ColorsManager.kWhite,
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(cubit.editHallImages[index]),
                  ),
                  GestureDetector(
                    onTap: () {
                      cubit.deleteNewImagesOnEditHall(index);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: ColorsManager.kRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
