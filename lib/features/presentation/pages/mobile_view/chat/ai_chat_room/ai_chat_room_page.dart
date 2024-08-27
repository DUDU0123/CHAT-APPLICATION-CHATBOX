import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/box_ai/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/ai/ai_chatbar_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/ai/ai_messages_stream_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/ai/ai_small_widgets.dart';

class AIChatRoomPage extends StatelessWidget {
  AIChatRoomPage({super.key});
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: aiAppBarTitle(context: context, theme: theme),
        actions: [
          appBarActions(),
        ],
      ),
      body: Stack(
        children: [
          aiRoomBg(
            context: context,
          ),
          Column(
            children: [
              Expanded(
                child: BlocConsumer<BoxAIBloc, BoxAIState>(
                  listener: (context, state) {
                    if (state is BoxAIErrorState) {
                      commonSnackBarWidget(
                        context: context,
                        contentText: state.errorMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    return aiMessagesStreamWidget(
                      scrollController: scrollController,
                      state: state,
                    );
                  },
                ),
              ),
              AIChatBarWidget(
                focusNode: focusNode,
                scrollController: scrollController,
              ),
            ],
          ),
        ],
      ),
    );
  }
}




