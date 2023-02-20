


import 'dart:html' as html;

class WebDownloadService  {
  @override
  Future<void> download({required String url}) async {
    html.window.open(url, "_blank");
  }
}