// home_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_repo/AddVideoModal/add_video_modal.dart';
import 'package:video_repo/screens/video_player_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_repo/components/custom_text_field.dart';
import 'package:video_repo/localization/strings.dart';
import 'package:video_repo/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_repo/styles/app_colors.dart';
import 'package:video_repo/styles/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _filteredVideos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _searchController.addListener(_filterVideos);
  }

  Future<void> _loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final videosString = prefs.getString('videos');
    if (videosString != null) {
      setState(() {
        _videos = List<Map<String, dynamic>>.from(json.decode(videosString));
        _filteredVideos = _videos;
      });
    }
  }

  Future<void> _saveVideos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('videos', json.encode(_videos));
  }

  void _addVideo(String title, XFile videoFile) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      quality: 25,
    );

    setState(() {
      _videos.add({
        'title': title,
        'videoFile': videoFile.path,
        'thumbnail': thumbnail,
      });
      _filteredVideos = _videos;
      _saveVideos();
    });
  }

  void _deleteVideo(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: const Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _videos.removeAt(index);
                  _filteredVideos = _videos;
                  _saveVideos();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _shareVideo(String videoFilePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController messageController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Share Video'),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(hintText: 'Enter your message'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                XFile videoFile = XFile(videoFilePath);
                Share.shareXFiles([videoFile],
                    text: messageController.text.isNotEmpty
                        ? messageController.text
                        : '');
                Navigator.of(context).pop();
              },
              child: const Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _filterVideos() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredVideos = _videos;
      } else {
        _filteredVideos = _videos
            .where((video) => video['title']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            snap: true,
            centerTitle: true,
            floating: true,
            title: const Padding(
              padding: AppPaddings.all8,
              child: Text(AppStrings.appBarTitle,
                  style: AppTextStyles.appBarTitle),
            ),
            bottom: AppBar(
              title: Padding(
                padding: AppPaddings.all8,
                child: CustomTextField(
                  hintText: AppStrings.searchHint,
                  icon: null,
                  controller: _searchController,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredVideos.length,
                itemBuilder: (context, index) {
                  final video = _filteredVideos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoFile: File(video['videoFile']),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppBorders.radius),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: FileImage(File(video['thumbnail'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(AppBorders.radius)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        video['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.share,
                                            color: Colors.white),
                                        onPressed: () {
                                          _shareVideo(video['videoFile']);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white),
                                        onPressed: () {
                                          _deleteVideo(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              size: 64,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddVideoModal(onAddVideo: _addVideo);
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 55),
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorders.radius),
              ),
            ),
            child: const Text(AppStrings.addNewVideo,
                style: AppTextStyles.modalButtonText),
          ),
        ),
      ],
    );
  }
}
