
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/config/theme/theme_constants.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';

class PhoneNumberRecieveField extends StatelessWidget {
  const PhoneNumberRecieveField({
    super.key,
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;
  @override
  Widget build(BuildContext context) {
    final theme = ThemeConstants.theme(context: context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: screenWidth(context: context),
      height: 50.sp,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColor,
        ),
        color: kTransparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCountryPicker(
                countryListTheme: CountryListThemeData(
                  backgroundColor: theme.colorScheme.onTertiary,
                  bottomSheetHeight: screenHeight(context: context) / 2,
                  borderRadius: BorderRadius.circular(15.sp),
                ),
                context: context,
                onSelect: (selectedCountry) {
                  context.read<AuthenticationBloc>().add(
                        CountrySelectedEvent(
                          selectedCountry: selectedCountry,
                        ),
                      );
                },
              );
            },
            child: countrySelectedShowWidget(),
          ),
          kWidth2,
          VerticalDivider(
            color: iconGreyColor,
            endIndent: 5,
            indent: 5,
          ),
          Expanded(
            child: TextFieldCommon(
              style: fieldStyle(context: context),
              keyboardType: TextInputType.number,
              hintText: "Phone number",
              enabled: true,
              textAlign: TextAlign.start,
              controller: phoneNumberController,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
