
import 'package:flutter/material.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewSection extends StatelessWidget {
  const PhotoViewSection({super.key, required this.imageToShow});

  final String imageToShow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhite),
        backgroundColor: kBlack,
      ),
      body: PhotoView(
        loadingBuilder: (context, event) {
          return commonAnimationWidget(
            context: context,
            lottie: settingsLottie,
            isTextNeeded: false,
          );
        },
        imageProvider: NetworkImage(imageToShow),
      ),
    );
  }
}
