// add_video_modal.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_repo/styles/app_colors.dart';
import 'package:video_repo/styles/app_text_styles.dart';
import 'package:video_repo/components/custom_text_field.dart';
import 'package:video_repo/localization/strings.dart';
import 'package:video_repo/utils/constants.dart';

class AddVideoModal extends StatefulWidget {
  final Function(String, XFile) onAddVideo;

  const AddVideoModal({required this.onAddVideo, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddVideoModalState createState() => _AddVideoModalState();
}

class _AddVideoModalState extends State<AddVideoModal> {
  final TextEditingController _titleController = TextEditingController();
  XFile? _videoFile;

  void _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = pickedFile;
    });
  }

  void _showEmptyTitleAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Title'),
          content: const Text('Please enter a title for the video.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(AppStrings.enterKeyword,
                  style: AppTextStyles.modalTitle),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomTextField(
                hintText: AppStrings.exampleHint,
                icon: null,
                controller: _titleController,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.red),
                  color: AppColors.lightRed,
                  borderRadius: BorderRadius.circular(AppBorders.radius),
                ),
                child: InkWell(
                  onTap: _pickVideo,
                  child: _videoFile == null
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: Image(
                                      height: 70,
                                      image: AssetImage('assets/images/bg.png'),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 8.5),
                                      child: Image(
                                        height: 40,
                                        image: AssetImage(
                                            'assets/images/video.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(AppStrings.selectVideo,
                                  style: AppTextStyles.selectVideoText),
                            ],
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 50,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Video Added",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty) {
                    _showEmptyTitleAlert();
                  } else if (_videoFile != null) {
                    widget.onAddVideo(_titleController.text, _videoFile!);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 49),
                  backgroundColor:
                      _videoFile == null ? AppColors.red : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorders.radius),
                  ),
                ),
                child: const Text(AppStrings.add,
                    style: AppTextStyles.modalButtonText),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
