import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:official_chatbox_application/core/constants/colors.dart';
import 'package:official_chatbox_application/core/constants/height_width.dart';
import 'package:official_chatbox_application/core/utils/small_common_widgets.dart';
import 'package:official_chatbox_application/features/data/models/chat_model/chat_model.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/common_widgets/text_field_common.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    context.read<ChatBloc>().add(GetAllChatsEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFieldCommon(
          onChanged: (value) {
            context.read<ChatBloc>().add(ChatSearchEvent(searchInput: value));
          },
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
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return StreamBuilder<List<ChatModel>>(
            stream: state.chatList,
            builder: (context, snapshot) {
              if (snapshot.data==null) {
                return emptyShowWidget(context: context, text: "No data available");
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemBuilder: (context, index) {
                  return ChatListTileWidget(
                    receiverID: snapshot.data![index].receiverID,
                    userProfileImage:  snapshot.data![index].receiverProfileImage,
                    chatModel: snapshot.data![index],
                    userName: snapshot.data![index].receiverName??'',
                    isGroup: false,
                  );
                },
                separatorBuilder: (context, index) => kHeight5,
                itemCount: snapshot.data!.length,
              );
            }
          );
        },
      ),
    );
  }
}
