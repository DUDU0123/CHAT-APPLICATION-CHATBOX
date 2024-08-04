
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/photo_view_section.dart';

class SettingsProfileImageAvatarWidget extends StatelessWidget {
  const SettingsProfileImageAvatarWidget({
    super.key,
    required this.userProfileImage,
  });
  final String? userProfileImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       userProfileImage!=null ?userProfileImage!.isNotEmpty? Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewSection(
              imageToShow: userProfileImage!,
            ),
          ),
        ): null:null;
      },
      child: userProfileImageContainerWidget(
        context: context,
        containerRadius: 160,
      ),
    );
  }
}
