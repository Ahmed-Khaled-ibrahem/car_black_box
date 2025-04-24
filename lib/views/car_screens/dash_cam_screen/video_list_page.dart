import 'dart:io';
import 'package:car_black_box/controller/appCubit/app_cubit.dart';
import 'package:car_black_box/services/get_it.dart';
import 'package:car_black_box/views/car_screens/dash_cam_screen/video_player_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../models/car.dart';

class VideoListPage extends StatefulWidget {
  VideoListPage(this.car, {super.key});
  @override
  _VideoListPageState createState() => _VideoListPageState();
  Car car;
}

class _VideoListPageState extends State<VideoListPage> {
  List<String> videos = [];
  String esp32Ip = "192.168.1.3";
  bool isLoading = true;
  bool isDownloading = false;
  String? currentDownload;

  String _permissionStatus = "Unknown";
  String _storageResult = "Not tested yet";

  var _isDownloading = true;
  String? _currentDownload = "";
  var _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    esp32Ip = widget.car.ip ?? "192.168.1.3";
    fetchVideos();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    PermissionStatus status;

    // Determine the right permission based on Android version
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+: Use media permissions
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      } else {
        // Android 12 and below: Use storage permission
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
    } else {
      status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
    }

    setState(() {
      _permissionStatus = "After request: $status";
    });
    print("After request: $status");

    if (status.isGranted) {
      print("Permission granted!");
    } else if (status.isDenied) {
      print("Permission denied by user.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Storage permission is needed for this feature.")),
      );
    } else if (status.isPermanentlyDenied) {
      print("Permission permanently denied.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enable permission in app settings.")),
      );
      await openAppSettings();
    }
  }

  Future<void> _testStorage() async {
    try {
      Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        File testFile = File("${dir.path}/test.txt");
        await testFile.writeAsString("Permission works! ${DateTime.now()}");
        setState(() {
          _storageResult = "File written at: ${testFile.path}";
        });
        print("File written at: ${testFile.path}");
      } else {
        setState(() {
          _storageResult = "Failed to get storage directory.";
        });
      }
    } catch (e) {
      setState(() {
        _storageResult = "Error: $e";
      });
      print("Storage error: $e");
    }
  }

  Future<void> fetchVideos() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://$esp32Ip/videos'),
        headers: {"Connection": "close"},
      );

      if (response.statusCode == 200) {
        setState(() {
          videos =
              response.body.split('\n').where((v) => v.isNotEmpty).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> downloadVideo(String filename) async {
    setState(() {
      isDownloading = true;
      currentDownload = filename;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/${filename.split('/').last}';
      final file = File(filePath);

      final response = await http.get(
        Uri.parse('http://$esp32Ip/download?filename=/$filename'),
        headers: {"Connection": "close"},
      );

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved to: $filePath')),
        );
      } else {
        throw Exception('Download failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isDownloading = false;
        currentDownload = null;
      });
    }
  }

  Future<void> downloadVideoWithProgress(String filename) async {
    final httpClient = http.Client();
    final request = http.Request(
        'GET', Uri.parse('http://$esp32Ip/download?filename=/$filename'));
    final response = httpClient.send(request);

    setState(() {
      _isDownloading = true;
      _currentDownload = filename;
      _downloadProgress = 0;
    });

    try {
      final downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD);

      final appDir = await getApplicationDocumentsDirectory();
      // final filePath = '${appDir.path}/${filename.split('/').last}';
      final filePath = '$downloadsPath/${filename.split('/').last}';
      final file = File(filePath);

      final streamedResponse = await response;
      final contentLength = streamedResponse.contentLength ?? 0;
      int receivedLength = 0;

      final sink = file.openWrite();
      streamedResponse.stream.listen(
        (List<int> chunk) {
          receivedLength += chunk.length;
          setState(() {
            _downloadProgress = (receivedLength / contentLength * 100).toInt();
          });
          sink.add(chunk);
        },
        onDone: () async {
          await sink.close();
          setState(() {
            _isDownloading = false;
            _currentDownload = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Download complete and saved at Downloads')),
          );
        },
        onError: (e) {
          sink.close();
          setState(() {
            _isDownloading = false;
            _currentDownload = null;
          });
          throw e;
        },
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _currentDownload = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: ${e.toString()}')),
      );
    }
  }

  Future<void> deleteVideo(String filename) async {
    try {
      final response = await http.get(
        Uri.parse('http://$esp32Ip/delete?filename=/$filename'),
        headers: {"Connection": "close"},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted')),
        );
        fetchVideos(); // Refresh list
      } else {
        throw Exception('Delete failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void playVideo(String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoUrl:  'http://$esp32Ip/download?filename=/$filename'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchVideos,
          ),
        ],
      ),
      body: isLoading
          ?  Center(child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text('Trying to fetch videos...\non IP : $esp32Ip'),
              const SizedBox(height: 10),
              const Text('Please make sure esp32 is connected to same network', textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ))
          : videos.isEmpty
              ? const Center(child: Text('No videos found'))
              : ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final videoDate = video.split('_').first;
                    final videoTime = video.split('_').last.replaceAll('.avi', '').replaceAll('-', ':');

                    return ListTile(
                      title: Text(
                        "Start Time: $videoTime",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(videoDate),
                      onTap: () => playVideo(video),
                      contentPadding:
                          const EdgeInsets.only(right: 10, left: 20),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isDownloading && _currentDownload == video)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  value: _downloadProgress / 100,
                                ),
                              ),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () => downloadVideoWithProgress(video),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteVideo(video),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
