import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:official_chatbox_application/features/data/data_sources/ai_data/ai_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/call_data/call_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/chat_data/chat_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/contact_data/contact_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/group_data/group_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/message_data/message_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/payment_data/payment_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/status_data/status_data.dart';
import 'package:official_chatbox_application/features/data/data_sources/user_data/user_data.dart';
import 'package:official_chatbox_application/features/data/repositories/ai_repo_impl/ai_repository_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/auth_repo_impl/authentication_repo_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/call_repo_impl/call_repository_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/chat_repository_impl/chat_repo_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/contact_repository_impl/contact_repo_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/group_repo_impl/group_repo_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/message_repo_impl/message_repo_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/payment_repo_impl/payment_repository_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/status_repository_impl/status_repository_impl.dart';
import 'package:official_chatbox_application/features/data/repositories/user_repository_impl/user_repository_impl.dart';
import 'package:official_chatbox_application/features/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/box_ai/boxai_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/call/call_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/group/group_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/media/media_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/message/message_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/payment/payment_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/status/status_bloc.dart';
import 'package:official_chatbox_application/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:provider/single_child_widget.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class AppBlocProvider {
  static List<SingleChildWidget> allBlocProviders = [
    BlocProvider(
      create: (context) => BottomNavBloc(),
    ),
    BlocProvider(
      create: (context) => AuthenticationBloc(
        firebaseAuth: firebaseAuth,
        userRepository: UserRepositoryImpl(
          userData: UserData(
            authenticationRepo:
                AuthenticationRepoImpl(firebaseAuth: firebaseAuth),
            fireBaseAuth: firebaseAuth,
            firestore: fireStore,
            firebaseStorage: firebaseStorage,
          ),
        ),
        authenticationRepo: AuthenticationRepoImpl(
          firebaseAuth: FirebaseAuth.instance,
        ),
      )..add(CheckUserLoggedInEvent()),
    ),
    BlocProvider(
      create: (context) => ContactBloc(
        contactRepository: ContactRepoImpl(
          contactData: ContactData(),
          firebaseFirestore: FirebaseFirestore.instance,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => MessageBloc(
        messageRepository: MessageRepoImpl(
          messageData: MessageData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
        ),
        chatRepo: ChatRepoImpl(
          chatData: ChatData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
          firebaseAuth: firebaseAuth,
        ),
      ),
    ),
    BlocProvider(
      create: (context) => UserBloc(
        firebaseAuth: FirebaseAuth.instance,
        userRepository: UserRepositoryImpl(
          userData: UserData(
            authenticationRepo: AuthenticationRepoImpl(
              firebaseAuth: firebaseAuth,
            ),
            fireBaseAuth: firebaseAuth,
            firestore: fireStore,
            firebaseStorage: firebaseStorage,
          ),
        ),
      )..add(GetCurrentUserData()),
    ),
    BlocProvider(
      create: (context) => ChatBloc(
        chatRepo: ChatRepoImpl(
          chatData: ChatData(
            firestore: fireStore,
            firebaseAuth: firebaseAuth,
          ),
          firebaseAuth: firebaseAuth,
        ),
      )..add(GetAllChatsEvent()),
    ),
    BlocProvider(
      create: (context) => GroupBloc(
        groupRepository: GroupRepoImpl(
          groupData: GroupData(
            firebaseAuth: firebaseAuth,
            firebaseFirestore: fireStore,
          ),
        ),
      )..add(GetAllGroupsEvent()),
    ),
    BlocProvider(
      create: (context) => StatusBloc(
        statusRepository: StatusRepositoryImpl(
          statusData: StatusData(
            firebaseFireStore: fireStore,
            fireBaseAuth: firebaseAuth,
            fireBaseStorage: firebaseStorage,
          ),
        ),
      )..add(StatusLoadEvent()),
    ),
    BlocProvider(
      create: (context) => CallBloc(
        callRepository: CallRepositoryImpl(
          callData: CallData(
            firebaseFirestore: fireStore,
          ),
        ),
      )..add(GetAllCallLogEvent()),
    ),
    BlocProvider(
      create: (context) => MediaBloc()..add(GetAllMediaFiles()),
    ),
    BlocProvider(
      create: (context) => BoxAIBloc(
        aiRepository: AIRepositoryImpl(
          aiData: AIData(
            firebaseFirestore: fireStore,
          ),
        ),
      )..add(GetAllAIChatMessages()),
    ),
    BlocProvider(
      create: (context) => PaymentBloc(
        paymentRepository: PaymentRepositoryImpl(
          paymentData: PaymentData(
            firebaseFirestore: fireStore,
          ),
        ),
      ),
    ),
  ];
}
