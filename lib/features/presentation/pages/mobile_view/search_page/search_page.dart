import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: ,
        title: TextFieldCommon(
          maxLines: 1,
          keyboardType: TextInputType.name,
          hintText: "Search chat...",
          style: fieldStyle(context: context)
              .copyWith(fontWeight: FontWeight.normal),
          controller: searchController,
          textAlign: TextAlign.start,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kTransparent,
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemBuilder: (context, index) {
          return ChatListTileWidget(
            chatModel: ChatModel(),
            userName: "User", isGroup: false,);
        },
        separatorBuilder: (context, index) => kHeight5,
        itemCount: 10,
      ),
    );
  }
}
