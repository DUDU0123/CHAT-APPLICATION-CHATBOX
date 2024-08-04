import 'package:share_plus/share_plus.dart';

Future<void> inviteToChatBoxApp() async {
  await Share.share(
      'We are excited to invite you to download and install ChatBox, your ultimate chat application, now available on the Amazon Appstore! ChatBox offers a seamless and engaging communication experience with its user-friendly interface, innovative features, and robust security. Connect with friends, family, and colleagues like never before. Don’t miss out—visit the Amazon Appstore today and make ChatBox your go-to app for all your messaging needs!');
}
