import 'package:path_provider/path_provider.dart';

class Files {
  final int id;
  final String file;
  final String title;
  String filepath = "";

  Files({required this.title, required this.file, required this.id}) {
    _setFilepath();
  }

  void _setFilepath() async {
    String rootDir = (await getExternalStorageDirectory())!.path;
    filepath = '$rootDir/Transcripts/$title$id.txt';
  }

  factory Files.fromJson(Map<String, dynamic> json) => Files(
        id: json['id'],
        title: json['title'],
        file: json['file'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'file': file,
        'filepath': filepath,
      };
}
