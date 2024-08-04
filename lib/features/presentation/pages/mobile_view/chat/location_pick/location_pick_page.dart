import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/data/models/group_model/group_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPickPage extends StatelessWidget {
  const LocationPickPage({super.key,  this.chatModel, this.groupModel,});
  final ChatModel? chatModel;
  final GroupModel? groupModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidgetCommon(text: "Pick Location"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
                width: screenWidth(context: context),
                height: screenHeight(context: context) / 2,
                child: FlutterMap(
                  options: const MapOptions(
                    //initialCenter: state.currentLocation,
                    initialZoom: 9.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          BlocBuilder<MessageBloc, MessageState>(builder: (contex, state) {
            if (state is MessageErrorState) {
              return commonErrorWidget(message: state.message);
            }
            if (state is CurrentLocationState) {
              log("Current Location: ${state.currentLocation}");
              log("Current Location: ${state.latitude}, ${state.longitude}");
              String locationUrl =
                  'https://www.google.com/maps/search/?api=1&query=${state.latitude},${state.longitude}';
              // context.read<MessageBloc>().add(
              //       LocationMessageSendEvent(
              //         chatModel: chatModel,
              //         location: locationUrl,
              //       ),
              //     );
              return SizedBox(
                width: screenWidth(context: context),
                height: screenHeight(context: context) / 2,
                child: FlutterMap(
                  options: const MapOptions(
                    //initialCenter: state.currentLocation,
                    initialZoom: 9.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return zeroMeasureWidget;
          }),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: buttonSmallTextColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp))),
              onPressed: () {
                context.read<MessageBloc>().add(LocationPickEvent());
              },
              child: TextWidgetCommon(
                text: "Send your current location",
                fontSize: 18.sp,
                textColor: kWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
