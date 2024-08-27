import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/core/utils/snackbar.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/widgets/call/call_logs_stream_builder_widget.dart';
import 'package:official_chatbox_application/features/presentation/widgets/call/call_widgets.dart';

class CallHomePage extends StatefulWidget {
  const CallHomePage({super.key});

  @override
  State<CallHomePage> createState() => _CallHomePageState();
}

class _CallHomePageState extends State<CallHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentCallTextWidget(),
          Expanded(
            child: BlocConsumer<CallBloc, CallState>(
              listener: (context, state) {
                if (state is CallErrorState) {
                  return commonSnackBarWidget(
                    context: context,
                    contentText: state.errorMessage,
                  );
                }
              },
              builder: (context, state) {
                return callLogsStreamBuilderWidget(state);
              },
            ),
          ),
        ],
      ),
    );
  }
}
