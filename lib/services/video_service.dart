import 'package:http/http.dart' as http;
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
//
//
// void convertAviToMp4(String inputPath, String outputPath) {
//   final FlutterFFmpeg ffmpeg = FlutterFFmpeg();
//   ffmpeg.execute('-i $inputPath $outputPath').then((rc) {
//     print("FFmpeg process exited with code $rc");
//   });
// }

class VideoService {
  static const String baseUrl = "http://192.168.1.6";

  static Future<List<String>> fetchVideoList() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      RegExp regex = RegExp(r"\/([\w\d_]+\.avi)");
      Iterable<Match> matches = regex.allMatches(response.body);
      List<String> videos = matches.map((match) => match.group(0) ?? "").toList();
      return videos;
    } else {
      return [];
    }
  }
}
