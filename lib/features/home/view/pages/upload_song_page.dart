import 'dart:io';

import 'package:client/core/utils/app_snackbar.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_field.dart';
import '../widgets/audio_wave.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final formKey = GlobalKey<FormState>();
  String songName = "";
  String artist = "";
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pickedAudio = await AppUtils.pickFile(FileType.audio);

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await AppUtils.pickFile(FileType.image);

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        actions: [
          IconButton(
            onPressed: () {
              if (!formKey.currentState!.validate() &&
                  selectedAudio == null &&
                  selectedImage == null) {
                AppSnackbar.showSnackabar(context, content: "Missing Fields!");
                return;
              }
              formKey.currentState!.save();

              if (selectedAudio != null && selectedImage != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songName,
                      artist: artist,
                      selectedColor: selectedColor,
                    );
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: selectImage,
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : DottedBorder(
                              color: Pallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      "Select the thumbnail for your song",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 40),
                    selectedAudio != null
                        ? AudioWave(path: selectedAudio!.path)
                        : CustomField(
                            // initValue: songName,
                            hintText: "Pick Song",
                            readOnly: true,
                            onTap: () => selectAudio(),
                          ),
                    const SizedBox(height: 20),
                    CustomField(
                      initValue: artist,
                      hintText: "Artist",
                      onSaved: (value) => artist = value ?? "",
                    ),
                    const SizedBox(height: 20),
                    CustomField(
                      initValue: songName,
                      hintText: "Song Name",
                      onSaved: (value) => songName = value ?? "",
                    ),
                    const SizedBox(height: 20),
                    ColorPicker(
                      color: selectedColor,
                      pickersEnabled: const {
                        ColorPickerType.wheel: true,
                      },
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
