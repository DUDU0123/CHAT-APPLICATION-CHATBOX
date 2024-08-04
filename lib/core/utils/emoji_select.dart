import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

Widget emojiSelect(
      {required TextEditingController textEditingController}) {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {},
      onBackspacePressed: () {
      },
      textEditingController:
          textEditingController,
      config: const Config(
        height: 256,
        checkPlatformCompatibility: true,
        swapCategoryAndBottomBar: false,
        skinToneConfig:  SkinToneConfig(),
        categoryViewConfig:  CategoryViewConfig(),
        bottomActionBarConfig:  BottomActionBarConfig(),
        searchViewConfig:  SearchViewConfig(),
      ),
    );
  }